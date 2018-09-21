class APODResponse{  
      String copyright;
      String date;
      String explanation = '';
      String hdurl;
      String media_type;
      String service_version;
      String title;
      String url; 

      APODResponse({ 
        this.copyright,this.date,this.explanation,this.hdurl,this.media_type,this.service_version,this.title,this.url,
      });
      
      static APODResponse fromJson(Map<String,dynamic> json){
        return APODResponse( 
            copyright: json['copyright'],
            date: json['date'],
            explanation: json['explanation'],
            hdurl: json['hdurl'],
            media_type: json['media_type'],
            service_version: json['service_version'],
            title: json['title'],
            url: json['url'],
        );
      }
      
      Map<String, dynamic> toJson() => { 
            'copyright': copyright,
            'date': date,
            'explanation': explanation,
            'hdurl': hdurl,
            'media_type': media_type,
            'service_version': service_version,
            'title': title,
            'url': url,
      };
    }