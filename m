From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Determining which spindle is out of order
Date: Mon, 08 Nov 2010 18:59:39 +0000
Message-ID: <4CD8489B.9060604@anonymous.org.uk>
References: <B9.A1.19545.A1017DC4@cdptpa-omtalb.mail.rr.com> <4CD7188C.2000206@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD7188C.2000206@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'Phil Turmel' <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/11/2010 21:22, John Robinson wrote:
[...]
> I also changed the find command again and it also works, with one nit,
> which is probably just CentOS/RHEL being odd.

Found another nitlet. I plugged in a USB hard drive caddy, with a drive 
in it, and it appears as follows:

Controller device @ pci0000:00/0000:00:1a.7/usb1/1-3/1-3:1.0 [usb-storage]
cat: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-3/1-3:1.0/../busnum: No 
such file or directory
   Bus 001 Device 002: ID 152d:2339 JMicron Technology Corp. / JMicron 
USA Technology Corp.  {SN: 021F807334FF}
     host10: /dev/sdd SAMSUNG HD400LJ

If there's anything I can help with, just let me know.

Cheers,

John.

