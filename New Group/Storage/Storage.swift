

import UIKit

struct Photo {
    var image: UIImage
}


struct PhotoSection {
    let photos: [Photo]
}

struct PhotoStorage {
    
    static let photoModel = [
        PhotoSection(
            photos: [
                Photo(image: #imageLiteral(resourceName: "bruce_lee_2")),
                Photo(image: #imageLiteral(resourceName: "d_chan")),
                Photo(image: #imageLiteral(resourceName: "ip_man_2")),
                Photo(image: #imageLiteral(resourceName: "van_damme")),
                Photo(image: #imageLiteral(resourceName: "jay_white")),
                Photo(image: #imageLiteral(resourceName: "ip_man_1")),
                Photo(image: #imageLiteral(resourceName: "will_smith")),
                Photo(image: #imageLiteral(resourceName: "once_in_china")),
                Photo(image: #imageLiteral(resourceName: "dzheki_chan_jeiden_smit")),
                Photo(image: #imageLiteral(resourceName: "bruce_lee_3")),
                
                Photo(image: #imageLiteral(resourceName: "chan")),
                Photo(image: #imageLiteral(resourceName: "boyko_yuriy")),
                Photo(image: #imageLiteral(resourceName: "kid")),
                Photo(image: #imageLiteral(resourceName: "stethem")),
                Photo(image: #imageLiteral(resourceName: "1S9fSKGT41Q")),
                Photo(image: #imageLiteral(resourceName: "welcome")),
                Photo(image: #imageLiteral(resourceName: "800-stallone-rocky-spin-off")),
                Photo(image: #imageLiteral(resourceName: "once_in_china_1")),
                Photo(image: #imageLiteral(resourceName: "stethem_1")),
                Photo(image: #imageLiteral(resourceName: "karate")),
                Photo(image: #imageLiteral(resourceName: "Ali")),
                
            ]
        )
    ]
}

enum PostSectionType {
    case photos
    case posts
}

struct Post {
    let image: UIImage
    let name: String
    let likes: String
    let views: String
    var description: String? = nil
}

struct PostSection{
    let type: PostSectionType
    let posts: [Post]?
    var footer: String? = nil
}

struct Storage {
    static let tableModel = [
        PostSection(
            type: .photos,
            posts: nil
            ),
        PostSection(
            type: .posts,
            posts: [
               Post(image: #imageLiteral(resourceName: "witcher"), name: "vedmak.official", likes: "Likes: 240", views: "Views: 312", description:"Новые кадры со съемок второго сезона сериала 'Ведьмак'"),
                Post(image: #imageLiteral(resourceName: "netology"), name: "Нетология. Меняем Карьеру через образование", likes: "Likes: 766", views: "Views: 893", description: "От \u{00AB}Hello, World!\u{00BB} до первого сложного iOS-приложения \u{2014} всего один курс. Если чувствуете в себе силу для покорения топов AppStore \u{2014} пора начинать дейтвовать! Профессия \u{00AB}iOS-разработчик\" \u{2014} тот самый путь, по которому стоит пройти до самого конца. Вы научитесь создавать приожения на языке Swift с нуля: от начинки до интерфейса. Чтобы закрепить знания на практике, каждый студент подготовит дипломную работу \u{2014} VK-like приложение с возможностью публиковать фотографии, использовать фильтры, ставить лайки и подписываться на других пользователей.")
            ]
        ),
        
        PostSection(
            type: .posts,
            posts: [
                Post(image: #imageLiteral(resourceName: "ip_man"), name: "Ип Ман. Учитель Брюса Ли, человек открывший миру стиль Вин-Чун", likes: "Likes: 280", views: "Views: 634", description:"В 50-х — 60-х годах XX века в Гонконге Ип Ман первым начал открытое преподавание кунг-фу Вин Чун, которое до той поры оставалось клановым. В Европе и Америке известен также как учитель киноактера Брюса Ли, познакомившего Западный мир с китайскими боевыми искусствами. Неофициально именуется патриархом Вин Чун"),
               Post(image: #imageLiteral(resourceName: "bruce_lee"), name: "Брюс Ли. Человек-легенда", likes: "Likes: 820", views: "Views: 1233", description: "\u{00AB}Я говорю, опустоши свой ум, будь аморфным, бесформенным, как вода. Ты наливаешь воду в чашку, она становится чашкой. Ты наливаешь воду в бутылку, она становится бутылкой. Ты наливаешь воду в чайник, она становится чайником. Вода может течь, а может крушить. Будь водой, друг мой...\u{00BB} Философия Брюса Ли"),
            ]
        )

    ] 
    
}
