From: Jimmy Hedman <jimmy.hedman@southpole.se>
Subject: Re: Problem with auto-assembly on Itanium
Date: Thu, 10 Mar 2005 11:03:44 +0100
Message-ID: <1110449024.12242.2.camel@localhost>
References: <1110364128.14707.19.camel@localhost>
	 <20050309164352.GB21635@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050309164352.GB21635@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2005-03-09 at 17:43 +0100, Luca Berra wrote:
> On Wed, Mar 09, 2005 at 11:28:48AM +0100, Jimmy Hedman wrote:
> >Is there any way i can make this work? Could it be doable with mdadm in
> >a initrd?
> >
> mdassembled was devise for this purpose.
> 
> create an /etc/mdadm.conf with
> echo "DEVICE partitions" >> /etc/mdadm.conf
> /sbin/mdadm -D -b /dev/md0 | grep '^ARRAY' >> /etc/mdadm.conf
> 
> copy the mdadm.conf and mdassemble to initrd
> make linuxrc run mdassemble.

So there are no way of doing it the same way i386 does it, ie scanning
the partitions and assembly the raid by it self? Is this a bug on the
itanium (GPT partition scheme) or is this intentional?

// Jimmy





> L.
> 

