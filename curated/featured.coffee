# "featured" projects

module.exports =

  [
      displayName: 'Build a Slack Bot'
      domain: 'slack-bot'
      id: '095a1538-8c44-4b27-b0fe-936d194318c2'
      img: "https://cdn.glitch.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-slack-bot.png"
    ,
      displayName: 'Make a Messenger Bot'
      id: 'ca73ace5-3fff-4b8f-81c5-c64452145271'
      domain: 'messenger-bot'
      img: "https://cdn.glitch.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-facebook-messenger.png"
    ,
      displayName: 'Teach Alexa New Skills'
      domain: 'alexa-skill'
      id: '681cc882-059d-4b05-a1f6-6cbc099cc79c'
      img: "https://cdn.glitch.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-alexa.png"
  ]


### ARCHIVED FEATURES



  👻 NOTE: the format of features has changed:
    - `name` is now `displayName` 
    - `users` array does not need to be included




  name: 'Make a Messenger bot'
  id: 'ca73ace5-3fff-4b8f-81c5-c64452145271'
  domain: 'messenger-bot'
  img: "https://cdn.glitch.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-facebook-messenger.png"


  name: 'Start your own blog'
  domain: 'ghost'
  id: '9a2033a3-30d8-4658-93a8-3b5073c73237'
  img: "https://cdn.gomix.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2FghostFeature.png"
  users: [
      login: 'TryGhost'
      avatarUrl: 'https://avatars3.githubusercontent.com/u/2178663?v=3&s=48'
  ],
  
  name: 'Make a Messenger bot in minutes'
  domain: 'messenger-bot'
  id: 'ca73ace5-3fff-4b8f-81c5-c64452145271'
  img: "https://cdn.gomix.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-facebook-messenger.png"
  users: [
      login: 'fbsamples'
      avatarUrl: 'https://avatars1.githubusercontent.com/u/1541324?v=3&s=48'
  ]

[
      name: 'Big Game Bingo'
      domain: 'big-game-bingo'
      projectId: '902cbaf0-e4e9-47c0-80b2-fe7ef583d679'
      img: "https://cdn.gomix.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-big-game-advert-bingo.png"
      users: [
          login: 'STRd6'
          avatarUrl: 'https://avatars2.githubusercontent.com/u/18894?v=3&s=48'
        ,
          login: 'pketh'
          avatarUrl: 'https://avatars2.githubusercontent.com/u/877072?v=3&s=48'
      ]
    ,
      name: 'Quarterback Quiz'
      domain: 'quarterback-quiz'
      projectId: '56e665e5-e0a8-46c8-9476-8d9b731117dd'
      img: "https://cdn.gomix.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-quarterback-quiz.png"
      users: [
          login: 'garethx'
          avatarUrl: 'https://avatars3.githubusercontent.com/u/1830035?v=3&s=48'
      ]
    ,
      name: 'Super Bowl Squares'
      domain: 'superbowl-squares'
      projectId: '55dbb2a4-94d9-434f-9dcc-1432c975de1c'
      img: "https://cdn.gomix.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-superbowl-squares.png"
      users: [
          login: 'etamponi'
          avatarUrl: 'https://avatars3.githubusercontent.com/u/578612?v=3&s=48'
      ]
  ]


# projects that need better domain names
    ,
    
      projectId: '70b0550f-da2e-4d0e-bb9b-c81436d7d8d4',
      domain: 'time-mustang' # post-card-maker
      description: "Upload an image and it'll create and post out a postcard"
      users: [
          name: 'margalit'
          avatar: 'https://avatars2.githubusercontent.com/u/2268424?v=3&s=48'
      ]
      categoryIds: [6]

      projectId: '0e7166c0-de2d-4965-8448-0e932e9f7efa'
      domain: 'impossible-salmon'
      description: "A Slack slash command handler which will help you to quickly access and create data stored in Contentful"
      users: [
          name: 'stefanjudis'
          avatar: 'https://avatars1.githubusercontent.com/u/962099?v=3&s=48'
      ]
      categoryIds: [7,9]
    ,

    ,
      projectId: '0e7166c0-de2d-4965-8448-0e932e9f7efa'
      editorUrl: 'impossible-salmon'
      likes: 15
      remixes: null
      description: "A Slack slash command handler which will help you to quickly access and create data stored in Contentful"
      users: [
          name: 'stefanjudis'
          avatar: 'https://avatars1.githubusercontent.com/u/962099?v=3&s=48'
      ]
      categoryId: [7]
      partnerIds: [1]




name: 'Quarterback Quiz'
      url: 'quarterback-quiz'
      id: '56e665e5-e0a8-46c8-9476-8d9b731117dd'
      img: "https://cdn.gomix.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-quarterback-quiz.png"
      users: [
          name: 'garethx'
          avatar: 'https://avatars3.githubusercontent.com/u/1830035?v=3&s=48'
      ]      
    ,


featured: -> [
      name: 'Teach Alexa New Skills'
      url: 'alexa-skill'
      id: '681cc882-059d-4b05-a1f6-6cbc099cc79c'
      img: "https://cdn.hyperdev.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-alexa.png"
      users: [
          name: 'STRd6'
          avatar: 'https://avatars2.githubusercontent.com/u/18894?v=3&s=48'
        ,
          name: 'pketh'
          avatar: 'https://avatars2.githubusercontent.com/u/877072?v=3&s=48'
      ]
    ,
      name: 'Make Your Own Slack Bot'
      url: 'slack-bot'
      id: '095a1538-8c44-4b27-b0fe-936d194318c2'
      img: "https://cdn.hyperdev.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-slack-bot.png"
      users: [
          name: 'garethx'
          avatar: 'https://avatars3.githubusercontent.com/u/1830035?v=3&s=48'
      ]      
    ,
      name: 'Create an Instant Bootstrap Website'
      url: 'creative-theme'
      id: 'ab2a48b3-b6e1-4883-a4ea-045dfb87cdc8'
      img: "https://cdn.hyperdev.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-bootstrap.png"
      users: [
          name: 'davidtmiller'
          avatar: 'https://avatars3.githubusercontent.com/u/8400627?v=3&s=48'
      ]
  ]
  
  
  
        name: 'Create a web app for your cloudBit'
      url: 'littlebits-api'
      id: '9f67720d-ad82-43b1-a7a5-2edc81e35b48'
      img: "https://cdn.gomix.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-littlebits.png"
      users: [
          name: 'etamponi'
          avatar: 'https://avatars3.githubusercontent.com/u/578612?v=3&s=48'
      ]
      
      
// hardware + fb bot

  featured: -> [
      name: 'Trigger multiple applets at once'
      url: 'multi-ifttt-triggers'
      id: '4761356a-9369-4e79-9d1e-a8306e8c00b5'
      img: "https://cdn.gomix.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-ifttt.png"
      users: [
          name: 'garethx'
          avatar: 'https://avatars3.githubusercontent.com/u/1830035?v=3&s=48'
      ]      
    ,
      name: 'Create your own Google Home actions'
      url: 'google-home'
      id: 'af1e91ec-2f6d-4a37-82cb-21c8bd289460'
      img: "https://cdn.gomix.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-google-home.png"
      users: [
          name: 'STRd6'
          avatar: 'https://avatars2.githubusercontent.com/u/18894?v=3&s=48'
        ,
          name: 'pketh'
          avatar: 'https://avatars2.githubusercontent.com/u/877072?v=3&s=48'
      ]      
    ,
      name: 'Make a Messenger bot in minutes'
      url: 'messenger-bot'
      id: 'ca73ace5-3fff-4b8f-81c5-c64452145271'
      img: "https://cdn.gomix.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-facebook-messenger.png"
      users: [
          name: 'fbsamples'
          avatar: 'https://avatars1.githubusercontent.com/u/1541324?v=3&s=48'
      ]
  ]
      
    
// valentines

  featured: -> [
      name: 'Send a Valentine Message'
      url: 'valentine-message'
      id: 'fd4fea9d-291a-41e7-85ef-cd8304bd06fd'
      img: "https://cdn.gomix.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2FvalentineFeature.png"
      users: [
          name: 'teodora-n'
          avatar: 'https://avatars2.githubusercontent.com/u/7382104?v=3&s=48'
      ]
    ,
      name: 'Write a Geeky Ode to Love'
      url: 'love-code'
      id: '1c5a59c5-3182-48b5-accd-fd27675c7f22'
      img: "https://cdn.gomix.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2FloveCodeFeature.png"
      users: [
          name: 'edagarli'
          avatar: 'https://avatars3.githubusercontent.com/u/5710228?v=3&s=48'
      ]      
    ,
      name: 'Play a Valentine\'s Mini Game'
      url: 'a-door-able'
      id: 'c6d76020-c1f5-4466-b40e-f85bbe42363d'
      img: "https://cdn.gomix.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2FadoorableFeature.png"
      users: [
          name: 'ncase'
          avatar: 'https://avatars3.githubusercontent.com/u/825858?v=3&s=48'
      ]
  ]
  
  //
  // tech forward
  
  featured: -> [
      name: 'Make a Messenger bot in minutes'
      url: 'messenger-bot'
      id: 'ca73ace5-3fff-4b8f-81c5-c64452145271'
      img: "https://cdn.gomix.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-facebook-messenger.png"
      users: [
          name: 'fbsamples'
          avatar: 'https://avatars1.githubusercontent.com/u/1541324?v=3&s=48'
      ]
    ,
      name: 'Find Tools for Social Progress'
      url: 'tech-forward-2'
      id: '16d249c6-c928-4616-a548-3108bce18ead'
      img: "https://cdn.gomix.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2FtechForwardFeatureAlt.png"
      users: [
          name: 'mattstauffer'
          avatar: 'https://avatars3.githubusercontent.com/u/151829?v=3&s=48'
      ]      
    ,
      name: 'Create a cloudBit web app'
      url: 'littlebits-api'
      id: '9f67720d-ad82-43b1-a7a5-2edc81e35b48'
      img: "https://cdn.gomix.com/6ce807b5-7214-49d7-aadd-f11803bc35fd%2Ffeatured-littlebits.png"
      users: [
          name: 'etamponi'
          avatar: 'https://avatars3.githubusercontent.com/u/578612?v=3&s=48'
      ]
  ] 
###