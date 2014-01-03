From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 22:24:38 -0600
Message-ID: <52C63B86.3050501@hardwarefreak.com>
References: <52C1C01A.7010407@ubuntu.com> <52C57C7B.80400@shiftmail.org> <52C588A7.6010207@hardwarefreak.com> <52C59468.6080200@ubuntu.com> <52C5A9AA.9090300@hardwarefreak.com> <52C5BC28.2020003@gmail.com> <52C5EB62.1090807@hardwarefreak.com> <52C5EE8F.3090204@aei.mpg.de> <52C62B21.2090609@gmail.com> <52C62C5B.7080006@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C62C5B.7080006@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>, Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Cc: Phillip Susi <psusi@ubuntu.com>, joystick <joystick@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/2/2014 9:19 PM, Stan Hoeppner wrote:
> On 1/2/2014 9:14 PM, Joe Landman wrote:
> 
>> But they are 4k native and you can use them that way.   The 512 byte
>> layer is emulated.
> 
> Which series is this?  Is the mode switched via a jumper?

According to WD's web site, all of their "datacenter" drives are 512n or
512e, none are listed as native 4K.  Same for their consumer drives.

I have just located about a dozen Seagate enterprise SSHD and Savio 15K
models that are offered in native 4K.  These must be relatively new.  I
find no 4Kn high cap Seagate drives.

All of the HGST enterprise drives are 512n/512e, select few support 520/528.

Toshiba's drive spec sheets don't even list sector size...

-- 
Stan
