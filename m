From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: Inexpensive RAID1 controller for home server?
Date: Mon, 20 Aug 2012 07:59:17 +0800
Message-ID: <50317DD5.5090708@fnarfbargle.com>
References: <CAK2H+eeLncyi6tCrM-vEhDzT7ykOA6LJP+Qka56rxUFGv2_urw@mail.gmail.com> <50306707.40302@hardwarefreak.com> <20120819153443.7f697ca6@natsu> <50315F39.2030404@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50315F39.2030404@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Roman Mamedov <rm@romanrm.ru>, Mark Knecht <markknecht@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20/08/12 05:48, Stan Hoeppner wrote:
> Roman has a beef with SiI. It's unfounded and unsubstantiated, but he has one nonetheless. He also 
> apparently has a beef with me for constantly correcting him on these issues. Believe who you wish. 
> I simply recommend you do your homework and independently verify everyone's claims. Or, you can 
> simply buy any ~$20 HBA, and if it doesn't work, return it and get a different one. 

Coming from someone who lost gigabytes of data to silent and unreported corruption in precisely the 
fashion Roman is talking about (in fact it was his pointer that lead me to diagnose the card as 
bad), It'll be a cold day in hell before I recommend a SIL card to anybody.

Now, I bought my card from vendor in the Middle East, and it was an odd far-eastern brand with 
little or no backup, so it may well be an artefact of the cards layout or manufacture that caused it 
to occur. The fact it was reproducible in precisely the same manner as all the other reported issues 
points toward a common fault of some kind.

I stumped up a bit more cash and bought 4 "IBM" branded LSI SAS cards from fleabay and have not 
looked back.

To quote Stan directly :
"Believe who you wish. I simply recommend you do your homework and independently verify everyone's 
claims. Or, you can simply buy any ~$20 HBA, and if it doesn't work, return it and get a different one."

The big problem with that last sentence in the context of the SIL card is often you won't know about 
the issue until it has eaten most of your data, and done it so slowly and insidiously that your 3 
months of rotating backups are corrupted also.

But then I'm not espousing contents of other peoples blogs, only talking from first hand experience. 
As always, YMMV.

Brad
