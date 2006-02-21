From: Luca Berra <bluca@comedia.it>
Subject: Re: Bigendian issue with mdadm
Date: Tue, 21 Feb 2006 07:17:56 +0100
Message-ID: <20060221061755.GA24192@percy.comedia.it>
References: <fd8d0180602201338t5f728fem@mail.gmail.com> <17402.21590.564710.372935@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17402.21590.564710.372935@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 21, 2006 at 10:44:22AM +1100, Neil Brown wrote:
>On Monday February 20, francois.barre@gmail.com wrote:
>> Hi All,
>> 
>> Please, Help !
>> 
>> I've created a raid5 array on a x86 platform, and now wish to use it
>> on a mac mini (g4 based). But the problem is : the first is
>> little-endian, the second big-endian...
>> And it seams like md superblock disk format is hostendian, so how
>> should I say mdadm to use a endianness ?
>> 
>
>Read the man page several times?
>
>Look for "--update=byteorder"
>
>You need mdadm-2.0 or later.
>
besides IIRC version 1 super block is always little-endan.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
