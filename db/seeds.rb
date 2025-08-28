# Clear existing data
Doubt.destroy_all
Student.destroy_all
Comment.destroy_all

puts "Creating students..."

students = [
  { name: "Rahib Hasan", email: "rahib@gmail.com", password: "123456" },
  { name: "Alice Johnson", email: "alice@example.com", password: "password" },
  { name: "Bob Smith", email: "bob@example.com", password: "password" },
  { name: "Charlie Lee", email: "charlie@example.com", password: "password" }
].map { |attrs| Student.create!(attrs) }

puts "Created #{students.count} students."

puts "Creating doubts..."

sample_titles = [
  "How does Ruby on Rails handle background jobs?",
  "What is the difference between has_many and has_one?",
  "How to validate rich text fields in Rails?",
  "Best practices for structuring a Q&A platform database?",
  "How to properly set timezone in Rails apps?"
]

sample_descriptions = [
  "I want to understand how Rails ActiveJob works. Can someone explain with examples?",
  "I am confused between `has_many` and `has_one` associations. What are the differences and use cases?",
  "I tried adding a rich text area to my model, but validations don't seem to work. How do I validate rich text?",
  "I am designing a Q&A website. How should I structure my tables for students, questions, and answers efficiently?",
  "I set `config.time_zone` but times still seem wrong in views. How should Rails handle timezones properly?"
]

sample_comment_bodies = [
  "Thanks for asking! This helped me understand better.",
  "I think you should check the official Rails guide on this.",
  "Can you clarify what you mean by 'validations'?",
  "This is exactly what I was struggling with!",
  "I would also like to know the answer to this."
]

20.times do
  student = students.sample
  title = sample_titles.sample
  description = sample_descriptions.sample

  doubt = Doubt.create!(title:, description:, user: student)

  # Add 1–3 random comments per doubt
  rand(1..3).times do
    commenter = students.sample
    Comment.create!(
      body: sample_comment_bodies.sample,
      commentable: doubt,
      user: commenter
    )
  end
end

puts "Created 20 sample doubts with comments."
