From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: sub-array kicked out of raid6 on each reboot.
Date: Fri, 28 Jan 2011 21:28:55 +0100
Message-ID: <20110128212855.64339d06@atak.bl.pg.gda.pl>
References: <20110128211534.697017aa@atak.bl.pg.gda.pl>
	<20110129012156.00a935ec@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110129012156.00a935ec@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roman Mamedov said:     (by the date of Sat, 29 Jan 2011 01:21:56 +0500)

> On Fri, 28 Jan 2011 21:15:34 +0100
> Janek Kozicki <janek_listy@wp.pl> wrote:
> 
> > Is it possible that the order in which the arrays were created,
> > matters? Because when it worked I created the sub-array first, and
> > then I created the BIG array. And currently the sub-array is created
> > after the BIG one.
> 
> I believe the order in which they are listed in mdadm.conf matters here.
> And after changing that file, you may need to rebuild your initramfs
> (on current Debian, "update-initramfs -k all -u").

Hi,

backup:~# cat /etc/mdadm/mdadm.conf | grep -v "#"

DEVICE partitions
CREATE owner=root group=disk mode=0660 auto=yes
HOMEHOST <system>
MAILADDR root
ARRAY /dev/md/2  metadata=1.0 UUID=4fd340a6:c4db01d6:f71e03da:2dbdd574 name=backup:2
ARRAY /dev/md/6  metadata=1.1 UUID=78f253ba:5a19ff8a:6646aa2f:f5218d84 name=backup:6
ARRAY /dev/md/0  metadata=1.0 UUID=75b0f878:79539d6c:eef22092:f47a6e6f name=backup:0
ARRAY /dev/md/69 metadata=1.1 UUID=dd751cb0:63424a86:66b98082:4bd80dcb name=backup:69

The order, I think is correct, but I did not rebuild initramfs.
I will try that and let you know, thanks.

-- 
Janek Kozicki                               http://janek.kozicki.pl/  |
