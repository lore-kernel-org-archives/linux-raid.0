From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: LVM performance (was: Re: RAID5 to RAID6 reshape?)
Date: Tue, 19 Feb 2008 13:52:21 -0600
Message-ID: <cccedfc60802191152k11f0f093gf26e42ed7d888c6d@mail.gmail.com>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
	 <18360.8065.335494.142060@tree.ty.sabi.co.UK>
	 <20080217074526.29d3c5c5@hardcode42.net>
	 <20080218062604.05ae4821@szpak>
	 <aebf5d970802180438w7a4d40ban3f66ee1dbc38d259@mail.gmail.com>
	 <20080218154203.6e2d1483@szpak>
	 <47BB30DF.1080006@student.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47BB30DF.1080006@student.tuwien.ac.at>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Feb 19, 2008 1:41 PM, Oliver Martin
<oliver.martin@student.tuwien.ac.at> wrote:
> Janek Kozicki schrieb:
> > hold on. This might be related to raid chunk positioning with respect
> > to LVM chunk positioning. If they interfere there indeed may be some
> > performance drop. Best to make sure that those chunks are aligned together.
>
> Interesting. I'm seeing a 20% performance drop too, with default RAID
> and LVM chunk sizes of 64K and 4M, respectively. Since 64K divides 4M
> evenly, I'd think there shouldn't be such a big performance penalty.
> It's not like I care that much, I only have 100 Mbps ethernet anyway.
> I'm just wondering...
>
> $ hdparm -t /dev/md0
>
> /dev/md0:
>   Timing buffered disk reads:  148 MB in  3.01 seconds =  49.13 MB/sec
>
> $ hdparm -t /dev/dm-0
>
> /dev/dm-0:
>   Timing buffered disk reads:  116 MB in  3.04 seconds =  38.20 MB/sec

I'm getting better performance on a LV than on the underlying MD:

# hdparm -t /dev/md0

/dev/md0:
 Timing buffered disk reads:  408 MB in  3.01 seconds = 135.63 MB/sec
# hdparm -t /dev/raid/multimedia

/dev/raid/multimedia:
 Timing buffered disk reads:  434 MB in  3.01 seconds = 144.04 MB/sec
#

md0 is a 3-disk raid5, 64k chunk, alg. 2, using a bitmap comprised of
7200rpm sata drives from several manufacturers.



-- 
Jon
