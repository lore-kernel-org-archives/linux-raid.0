From: rob <rob@fantinibakery.com>
Subject: Re: mdadm --assemble --scan hassles....
Date: Tue, 28 Oct 2003 06:30:49 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F9E5369.6050203@fantinibakery.com>
References: <20031008111709.GV1277@hvs.envisage.co.za> <16270.5184.302596.951547@notabene.cse.unsw.edu.au> <20031025212433.GE23767@hvs.envisage.co.za> <16285.38655.754527.236684@notabene.cse.unsw.edu.au> <20031028062445.GD3236@hvs.envisage.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031028062445.GD3236@hvs.envisage.co.za>
To: Hendrik Visage <hvisage@envisage.co.za>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

AFAIK you don't need DEVICE and ARRAY entries in mdadm.conf

I only use MAILADDR    PROGRAM    entries to monitor the array.



Hendrik Visage wrote:

>On Tue, Oct 28, 2003 at 09:06:55AM +1100, Neil Brown wrote:
>  
>
>>On Saturday October 25, hvisage@envisage.co.za wrote:
>>    
>>
>>>>That would be because mdadm.conf describes /dev/md/1 as:
>>>>    UUID=c2a91233:5ffd5398:eac27773:e12945dd
>>>>but mdadm --examine doesn't show any arrays with that uuid.
>>>>
>>>>NeilBrown
>>>>        
>>>>
>>>Then how do I fix it??
>>>
>>>      
>>>
>>Edit /etc/mdadm.conf
>>    
>>
>
>I've tried without any succes as yet :(
>
>so what would the correct mdadm.conf look like in my case?
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>

