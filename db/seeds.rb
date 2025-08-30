DoubtStat.instance

puts "Creating students..."
# Static students for testing
static_students = [
  { name: "Test Student 1", email: "student1@test.com", password: "password123" },
  { name: "Test Student 2", email: "student2@test.com", password: "password123" },
  { name: "Test Student 3", email: "student3@test.com", password: "password123" }
].map { |attrs| Student.create!(attrs) }

# Faker students
faker_students = 7.times.map do
  Student.create!(name: Faker::Name.name, email: Faker::Internet.email, password: "password123")
end

students = static_students + faker_students

puts "Creating teaching assistants..."
# Static TAs for testing
static_tas = [
  { name: "Test TA 1", email: "ta1@test.com", password: "password123" },
  { name: "Test TA 2", email: "ta2@test.com", password: "password123" },
  { name: "Test TA 3", email: "ta3@test.com", password: "password123" }
].map { |attrs| TeachingAssistant.create!(attrs) }

# Faker TAs
faker_tas = 3.times.map do
  TeachingAssistant.create!(name: "TA #{Faker::Name.first_name}", email: Faker::Internet.email, password: "password123")
end

tas = static_tas + faker_tas

puts "Creating doubts..."
doubts = 15.times.map do
  Doubt.create!(
    title: Faker::Lorem.question,
    description: Faker::Lorem.paragraph,
    user: students.sample,
    created_at: rand(20..60).minutes.ago
  )
end

puts "Processing doubt assignment workflow..."
available_doubts = doubts.shuffle
available_tas = tas.dup

available_doubts.first(10).each do |doubt|
  # Step 1: TA accepts the doubt (creates assignment in accepted state)
  ta = available_tas.sample
  assignment = DoubtAssignment.create!(
    doubt: doubt,
    ta: ta,
    created_at: rand(doubt.created_at..10.minutes.ago)
  )
  
  # Remove TA from available pool (can't accept multiple)
  available_tas.delete(ta)
  
  # Step 2: Random decision - resolve or escalate
  if rand < 0.6  # 60% resolve directly
    assignment.answer = Faker::Lorem.paragraph
    assignment.save!  # This will auto-resolve due to answer presence
    available_tas << ta  # TA becomes available again after resolving
    
  else  # 40% escalate
    assignment.update!(status: :escalated)  # This will mark doubt as escalated        
    # Step 3: For escalated doubts, try reassignment (if TAs available)
    if available_tas.any? && rand < 0.7  # 70% chance of reassignment
      new_ta = available_tas.sample
      new_assignment = DoubtAssignment.create!(
        doubt: doubt,
        ta: new_ta,
        created_at: rand(assignment.created_at..Time.current)
      )
      available_tas.delete(new_ta)
      
      # Step 4: New TA decides - resolve or escalate again
      if rand < 0.8  # 80% resolve on second attempt
        new_assignment.answer = Faker::Lorem.paragraph
        new_assignment.save!  # Auto-resolves
        available_tas << new_ta
      else  # 20% escalate again
        new_assignment.update!(status: :escalated)
        available_tas << new_ta
      end
    end
    available_tas << ta
  end
  
  # Replenish available TAs if pool gets too small
  if available_tas.count < 2
    available_tas = tas.dup
  end
end

# Add minimal comments
doubts.sample(5).each do |doubt|
  Comment.create!(
    body: Faker::Lorem.sentence,
    commentable: doubt,
    user: students.sample
  )
end

puts "\nLOGIN CREDENTIALS:"
puts "Students: student1@test.com, student2@test.com, student3@test.com"  
puts "TAs: ta1@test.com, ta2@test.com, ta3@test.com"
puts "Password: password123"

puts "\nSUMMARY:"
puts "#{Student.count} students, #{TeachingAssistant.count} TAs"
puts "#{Doubt.count} doubts, #{DoubtAssignment.count} assignments"
puts "Open: #{Doubt.where(status: :pending, accepted: false).count}"
puts "Accepted: #{Doubt.where(status: :pending, accepted: true).count}"
puts "Escalated: #{Doubt.where(status: :escalated).count}"
puts "Resolved: #{Doubt.where(status: :resolved).count}"
