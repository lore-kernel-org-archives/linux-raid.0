From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: can I freeze I/O for some time to a given disk / md / dm	device?
Date: Tue, 16 Dec 2008 17:19:21 +0100
Message-ID: <4947D509.6080005@wpkg.org>
References: <49479897.1080500@wpkg.org> <20081216161312.GI18423@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081216161312.GI18423@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Linux IDE <linux-ide@vger.kernel.org>, Linux-Raid <linux-raid@vger.kernel.org>, LVM general discussion and development <linux-lvm@redhat.com>
List-Id: linux-raid.ids

Gabor Gombas schrieb:
> On Tue, Dec 16, 2008 at 01:01:27PM +0100, Tomasz Chmielewski wrote:
> 
>> Is it possible to "freeze I/O" for some time to a given disk / md / dm  
>> device?
>>
>> Say, "freeze I/O" so that userspace waits for any response for 30, 60  
>> seconds or more?
> 
> For real disks you can use /sys/block/sdX/device/unload_heads to achieve
> something similar (see Documentation/laptops/disk-shock-protection.txt
> in the kernel source about how to use it). That won't work for md/dm
> devices though.

Thanks, I think I have enough hints now.

Bryn M. Reeves on linux-lvm list suggested using dmsetup's 
suspend/resume, which seems to be the easiest way for this purpose 
(requires device mapper / LVM).


-- 
Tomasz Chmielewski
http://wpkg.org
