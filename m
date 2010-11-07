From: Phil Turmel <philip@turmel.org>
Subject: Re: Determining which spindle is out of order
Date: Sun, 07 Nov 2010 08:21:52 -0500
Message-ID: <4CD6A7F0.7030300@turmel.org>
References: <30.2B.19545.E5C25DC4@cdptpa-omtalb.mail.rr.com> <4CD57048.4020107@turmel.org> <4CD57867.4010207@anonymous.org.uk> <4CD57C17.8020303@turmel.org> <4CD6A141.5090601@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD6A141.5090601@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/07/2010 07:53 AM, John Robinson wrote:
> On 06/11/2010 16:02, Phil Turmel wrote:
>> On 11/06/2010 11:46 AM, John Robinson wrote:
> [...]
>>> Now I need to find udevadm I guess. It must have been introduced since the udev version that comes with RHEL/CentOS 5, which is udev-095-14.21.el5_5.1. rpmfind.net suggests it's only been in since version 118 or so. Never mind :-)
>>
>> Heh.  Anyone know the equivalent command in earlier versions of udev?
> 
> I think it's `udevinfo` instead of `udevadm info` - the comment in the ChangeLog for udev-117 is "udevadm: merge all udev tools into a single binary". But it doesn't work terribly well:
> 
> [root@beast describe_scsi]# udevinfo -q all -p /devices/pci0000\:00/0000\:00\:1f.2/
> no record for '/devices/pci0000:00/0000:00:1f.2/' in database
> 
> That's unfortunate. But it does know about that device if asked differently:
> 
> [root@beast describe_scsi]# udevinfo -a -p /devices/pci0000\:00/0000\:00\:1f.2/

Hmmm.  Can you try both of the above without the trailing slash?

[snip /]

> I suspect the udev version in EL5 just isn't going to give up the info you need, even if you did rewrite for the different sysfs paths :-(

The information is there, though.  I'll poke at it in the near future.

> Thanks for your efforts though!

You're welcome.

> Cheers,
> 
> John.

Phil
