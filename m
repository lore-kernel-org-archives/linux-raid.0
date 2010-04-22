From: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Thu, 22 Apr 2010 19:13:50 +0300
Message-ID: <201004221913.50692.eye.of.the.8eholder@gmail.com>
References: <4BAB8D41.4010801@gmail.com> <y2x5bdc1c8b1004211036ra8e10a43kc1a13c2b374a5f7b@mail.gmail.com> <4BCF4693.3020101@buttersideup.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BCF4693.3020101@buttersideup.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I believe that these disks only come in the "green" variety.  I recently
> picked up a 1.5 tb version for testing and cheap bulk storage, and I
> would not suggest using them in a raid array because the green drives
> firmware automatically parks the head after 8 seconds of inactivity and
> reduces the rpm of the disk.  The constant parking can quickly wear out
> the head under high use and there is no way to disable this "feature".

As previously mentioned wdidle utility can disable the head unloading.

> The specifications say it's good for 300,000 cycles, so do the
> math... getting 5 unloads per minute would lead to probable failure
> after 41 days.  Granted that is about worst case, but still something to
> watch out for.  In order to make it the entire 3 year warranty period,
> you need to stay under 11.4 unloads per hour.  If you have very little
> IO activity, or VERY MUCH, then this is entirely possible, but more
> moderate loads in the middle have been observed to cause hundreds of
> unloads per hour.

WD mentions in the customer help (Answer ID 5357) that these newer drives
were validated to 1M load/unload cycles and not 300K.

> 
> If you want to fix it, then wdidle3.exe worked for me.  Search for:
> 
> wdidle3_1_00.zip
> 
It worked fine for me too. I had a Load Cycle Count of 59, 15 mins
after connecting the drive for the first time. After running wdidle
the Count stopped at 104 and never increased again. I now have 11 hours
With wdidle 1.00 disabling the timer did nothing. I had to set the timer to
a large value. There is a newer version though (1.03) that supports
these new drives better. 
