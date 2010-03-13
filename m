From: Kapetanakis Giannis <bilias@edu.physics.uoc.gr>
Subject: Re: large filesystem corruptions
Date: Sat, 13 Mar 2010 11:25:54 +0200
Message-ID: <4B9B5A22.60108@edu.physics.uoc.gr>
References: <4B9A9D81.3000009@edu.physics.uoc.gr> <4B9AA5AC.9090005@redhat.com>	 <4B9ADC61.7080007@edu.physics.uoc.gr>	 <4B9AE28C.8030905@edu.physics.uoc.gr> <4877c76c1003121758w49cdeccas6865e65c9e985770@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003121758w49cdeccas6865e65c9e985770@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/03/10 03:58, Michael Evans wrote:

> Since you're using a device>2TB in size, I will assume you are using
> one of the three 'version 1' superblock types.  Either at the end 1.0,
> beginning 1.1 or 4kb in from the beginning.
>
> Please provide the full output of mdadm -Dvvs

I did a test with 1.1 metadata version.
Crashed again when I deleted the file from the large FS.

I did a mistake in my previous mail.
Kernel is not stock. It's the latest kernel from centos/redhat 5.4
System up2date.

I will open a ticket in Centos and Redhat bugzilla
and see how it goes.

Giannis
ps. Probably install fedora 12 64bit on Monday

