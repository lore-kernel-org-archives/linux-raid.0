From: Andy Dawson <A.J.Dawson@Bradford.ac.uk>
Subject: Re: raid'ing problems
Date: Fri, 21 Oct 2005 16:58:04 +0100 (GMT Standard Time)
Message-ID: <Pine.WNT.4.63.0510211654540.3824@ender>
References: <1129899043.32525.4.camel@plauda5.rx30.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1129899043.32525.4.camel@plauda5.rx30.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Lauda <plauda@rx30.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Peter,

I'd follow the instructions here: 
http://www.linuxhowtos.org/System/raid.htm

Note that I've not actually tried it myself, but from a quick glance 
through appears to be reasonable.

Of course you do have a backup before you start just in case, don't you?

Following the instructions at the end of the page worked for me when I was 
setting up Grub to boot from a software RAID1 array.

Regards
Andy


On Fri, 21 Oct 2005, Peter Lauda wrote:

> If anyone is listening....
>
> I have read the howto's and all the FAQ's I can find. I am trying to do
> the following and having zero success:
>
> An installed system needs to have a second disk setup with the first as
> a raid 1 set.
>
> I have been able to boot from a CD and create the md0 md1 and md2
> devices. I cannot however, get any of these to mount afterwards. I
> assume that mount doesn't know what type of fs these are and I'm not
> seeing anything in the docs about what type I can use.
>
> Eventually this raid set needs to be able to boot. We use grub as the
> boot loader. If anyone has done this or knows how and can offer any
> assistance I thank you in advance.
>
> We are using 2.4.29 kernel in a home rolled package but have both
> raidtools and mdadm tools available.
>
> Cheers!
> --p
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Dr. Andy Dawson
A.J.Dawson@Bradford.ac.uk
http://www.mossie.org
http://www.museum-explorer.org.uk

  Never attribute to malice that which can adequately be explained by stupidity
