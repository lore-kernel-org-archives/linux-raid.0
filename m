From: Ninti Systems <office@ninti.com.au>
Subject: RE: /boot RAID1
Date: 31 Mar 2004 12:55:37 +0930
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1080703536.10119.35.camel@localhost>
References: <200403310306.i2V36lW16729@dns1.watkins-home.com>
Reply-To: office@ninti.com.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200403310306.i2V36lW16729@dns1.watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Yes, I've used RedHat for a few years and still like RH9.0 as a desktop
machine. I could set RAID up easily on RedHat but I never really
understood anything much about it, and especially how to manage, tweak,
fix or monitor it later on.

I've tried several distros out as the basis of a server project I'm
working on and have found Slackware 9.1 to be the best all-round
solution in terms of speed, stability and *overall* simplicity.

I'm comfortable on the command line (the server has no GUI) and am
actually keen to learn how to use the command line tools. When I get the
process right, I'll simply script it as much as possible.

:-)


On Wed, 2004-03-31 at 12:36, Guy wrote:
> I can't answer your question, but...
> 
> RedHat 9.0 makes it real easy to configure RAID during the install.
> You can also configure LVM during the install if you want.
> So, no need to do these post-install things you now need to do.
> I am using RedHat 9.0 myself.
> 
> I bet RedHat's Fedora is as easy.
> 
> Guy
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ninti Systems
> Sent: Tuesday, March 30, 2004 9:34 PM
> To: RAID Linux
> Subject: /boot RAID1
> 
> I've set up everything to switch my fresh Slackware 9.1 install on
> /dev/hda over to RAID1 devices set up on /dev/hda (currently 'missing')
> and /dev/hdc.
> 
> Before I switch, I need to check one thing which isn't clear to me from
> the Software RAID HowTo:
> 
> I currently have a separate partition (/dev/hda1) for /boot. Can this
> partition also be switched over to RAID1 (on /dev/md1) or must the /boot
> partition always be on a non-RAID device? 
> 
> RAID1 support appears to compiled into the Slackware bare.i kernel I am
> using. Autodetection on boot is working.
> 
> Thanks
> Mick
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
--------------------------------------
Ninti Systems: Smart IT Solutions
Michael Hall
Mobile: 0429 095 392
Ph/Fax: 08 8953 1442       
Email:  office at ninti dot com dot au
Web:    http://ninti.com.au
--------------------------------------

