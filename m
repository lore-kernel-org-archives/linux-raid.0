From: "WNSDEV" <pete@wnsdev.com>
Subject: RE: Linux raid wiki
Date: Fri, 23 Sep 2016 10:35:32 -0700
Message-ID: <002a01d215c0$e3f20980$abd61c80$@wnsdev.com>
References: <57E469E0.4020005@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57E469E0.4020005@youngman.org.uk>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Wols Lists' <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Wol,

Thanks for your work on the wiki... I'm sending a virtual bouquet.   I've been tracking down an issue regarding role numbers which I've posted to the list http://marc.info/?l=linux-raid&m=147439325405842&w=2.  In that process I've come across other postings that say information in the wiki is incorrect so maybe this is an opportunity to update this part of the wiki.

According to  https://raid.wiki.kernel.org/index.php/Mdstat  we find:

"The raid role numbers [#] following each device indicate its role, or function, within the raid set. Any device with "n" or higher are spare disks. 0,1,..,n-1 are for the working array. Notice that there is no device 3."

But according to the following two postings, http://www.spinics.net/lists/raid/msg44491.html and http://www.spinics.net/lists/raid/msg49766.html
the information in the wiki about the numbers in brackets (role numbers ) is wrong.

Thanks,
Peter Sangas


-----Original Message-----
From: Wols Lists [mailto:antlists@youngman.org.uk] 
Sent: Thursday, September 22, 2016 4:32 PM
To: linux-raid@vger.kernel.org
Subject: Linux raid wiki

I've finally got myself access to the wiki :-) and have been working on bringing it a bit more up-to-date.

I've somewhat updated the overview section, so by all means be critical, but it's not mostly my work.

I've added the "When Things Go Wrogn" section, but so far only the first two pages - "Asking for help" and "Timeout Mismatch" - are all my work. 
The other three pages were already there, but I moved them here because I felt they belonged here.

Please feel free to criticize it (or offer bouquets :-), and give advice as how to improve things, either in private email or on the list.

I know we're a friendly bunch, but so many people seem to keep coming for the same problems over and over again, and I want this to be an up-to-date resource we can point people at to try and help them help themselves.

(And if you think any stuff is out-of-date and misleading, tell me. I'm planning to create a "softtware archaeology" section for all the stuff that is no longer relevant, but might be wanted by people looking after old systems.)

Cheers,
Wol
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

