# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
names = "The Voice, American Idol, Mad Men, Dancing with the Stars, Scandal, NCIS, Game of Thrones, Grey's Anatomy, Person of Interest, The Big Bang Theory, Two and a Half Men, Chicago Fire, The Bachelor, The Following, Revolution, The Carrie Diaries, Vegas, Nashville, Arrow, The Amazing Race , Elementary, Hannibal, Modern Family, Parks and Recreation, Criminal Minds, Bones, Revenge, New Girl, Suits, Breaking Bad, True Blood, Once Upon a Time, Glee, Keeping Up with the Kardashians, 2 Broke Girls, Justified, Castle, House of Cards, How I Met Your Mother, 30 Rock, Community, The Vampire Diaries, One Life to Live, Dexter, The Walking Dead, Pretty Little Liars, Nikita, Bad Girls Club, CSI: Crime Scene Investigation, Days of Our Lives, Secret Life of the American Teenager, The Americans, All My Children, Archer, Girls, House of Lies, Shameless, Smash, Masterpiece, Luther, 90210, Cougar Town, Homeland, Bunheads, Psych, Necessary Roughness, White Collar, Alphas, Being Human, Anger Management, Dallas, Happy Endings, The Mindy Project, The Newsroom, Nurse Jackie, Portlandia, Project Runway, Saturday Night Live, Jimmy Kimmel Live, Colbert Report, The Daily Show With Jon Stewart, Spartacus, Southland, Hawaii Five-0, Grimm, iCarly, Supernatural, Californication, Family Guy, The Young and the Restless, Law &amp; Order: Special Victims Unit, American Horror Story: Asylum, The Office, Fringe, The Mentalist, The Good Wife, Private Practice, Sons of Anarchy, Dr. Oz Show, General Hospital, "
names = names.split(", ")

names.each do |name|
  begin
    s = Show.find_by_name(name)
    s = Show.create(name: name) if s.nil?
  rescue Errno::ECONNRESET => e
    retry
  end
  begin
    Episode.pull_episodes(s) if s
  rescue Errno::ECONNRESET => e
    retry
  end
end