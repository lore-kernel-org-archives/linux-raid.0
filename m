From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm mail option configuration
Date: Wed, 29 May 2002 20:46:07 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15604.45423.781175.499314@notabene.cse.unsw.edu.au>
References: <5.1.0.14.0.20020528111927.01f28280@205.233.215.4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jeff Hill on Tuesday May 28
To: Jeff Hill <jhill@hronline.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 28, jhill@hronline.com wrote:
> I'm having problems configuring mdadm to send e-mail alerts. From past list 
> discussions I configured it with:
> 
> devo:/#  cat /etc/mdadm.conf
> 
> DEVICE /dev/hd*[0-9] /dev/sd*[0-9]
> ARRAY /dev/md1 level=raid1 num-devices=2 
> UUID=8e0114bb:e5b3a608:048bed2d:5fe33724
> ARRAY /dev/md2 level=raid1 num-devices=2 
> UUID=434dd79d:0c046e9b:867e8d98:86bdb5da
> ARRAY /dev/md3 level=raid1 num-devices=2 
> UUID=9a9a2078:44c22d83:25a32457:db7e3783
> ARRAY /dev/md5 level=raid1 num-devices=2 
> UUID=e3254469:34147651:c9298800:5a84cd06
> ARRAY /dev/md6 level=raid1 num-devices=2 
> UUID=80c78ac7:c0f4442a:3dd6517d:57edc79e
> MAILADDR jhill@hrpost.com
> PROGRAM /usr/local/sbin/raidalert

You need white-space infront of the UUID= bits, as it is continuation
of the previous line... or did you suffer a mailer word wrap??

Do you have a "/usr/lib/sendmail" or is it somewhere else on your
system?

> 
> ------
> Then, I just have an init script that runs:
> 
> 	/sbin/mdadm -Fs --delay=600 &

Why 600 (10 minutes)?? I would suggest 60seconds for normal operation
and 1 second for testing.

NeilBrown
