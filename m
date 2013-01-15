From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Mon, 14 Jan 2013 20:25:53 -0700
Message-ID: <201301142025.54033.thomas@fjellstrom.ca>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301141453.13819.thomas@fjellstrom.ca> <95B458E1-8825-44D1-BCD5-1796A1E69FAE@colorremedies.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <95B458E1-8825-44D1-BCD5-1796A1E69FAE@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>, "stan@hardwarefreak.com Hoeppner" <stan@hardwarefreak.com>, Tommy Apel Hansen <tommyapeldk@gmail.com>
List-Id: linux-raid.ids

On Mon Jan 14, 2013, Chris Murphy wrote:
> On Jan 14, 2013, at 2:53 PM, Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:
> >                                                            random  random   
> >                                                            bkwd   record  
> >                                                            stride
> >              
> >              KB  reclen   write rewrite    read    reread    read   write
> >                 read  rewrite     read   fwrite frewrite   fread 
> >              freread
> >        
> >        33554432    8192  124664  121973   524509   527971  376880  104357
> >         336083    40088   392683   213941   215453  631122   631617
> > 
> > I assume that is to you liking?
> 
> No it's getting hosed for me too, I think it's just too wide for the forum.
> Pastebin it. And I suggest you post the one that has the variable reclen
> not just the 8MB result.

Forum? The email I got back views fine in my email program. Well mostly fine,
one of the header lines is offset by one character.

> And also, now I'm confused because the above reclen8192 result doesn't
> match with the one you posted from before, so I'm goingn to guess this is
> the one with -I. My suggestion is that you put into the pastebin the
> command you used to arrive at the results. Both are important.

Yeah, total screw up on my part there. I still had the contents from replying
to Tommy with a different test. *sigh* *headdesk*

http://pastebin.com/ffaKiKnN

moose@mrbig:/mnt/mrbig/data/test$ time iozone -a -s 32G -r 8M
                                                            random  random    bkwd   record   stride                                   
      KB  reclen   write rewrite    read    reread    read   write    read  rewrite     read   fwrite frewrite   fread  freread
33554432    8192  208232  210453   628247   630950  370444  163451  382472  4889055   618370   210211   216416  714091   709861

> > p.s. I am seriously tempted to play your little flame game,
> > but It's not worth the time.
> 
> Don't say that or people won't help. If it's your first day at the rodeo
> taking a bit of a beating and you announce it's not worth it, most people
> will agree with you and stop playing.

I'm a little confused. People won't help if I state that I'm uninterested in a
flame war? I've spent way more than enough time engaging in flame wars on the
internet.

> Chris Murphy


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
