From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Fri, 08 Feb 2013 00:08:17 +1100
Message-ID: <5113A741.7030504@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <5113A3D4.6000605@turmel.org> <5113A4E9.5020005@websitemanagers.com.au> <5113A628.6010304@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5113A628.6010304@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/02/13 00:03, Phil Turmel wrote:
> On 02/07/2013 07:58 AM, Adam Goryachev wrote:
>> On 07/02/13 23:53, Phil Turmel wrote:
>>> On 02/07/2013 07:49 AM, Adam Goryachev wrote:
>>>> Well, if I can re-trim daily, and have enough clean space to work for 2
>>>> days, then I should never hit this problem.... Assuming it loses *that
>>>> much* performance....
> 
> You just have nothing useful on the server side for trim to do.
> (Although you should manually trim the unpartitioned space.  You only
> need to do so once.)

If the unpartitioned space has *never* been used/partitioned, then I
presume TRIM wouldn't help here then.... So, I guess I might as well
leave this one alone.

Though, like I said, would adding an extra SSD to the RAID5, and
reducing the size of all partitions by 20%, and then doing TRIM on that
newly freed space, would that improve performance because of the extra
free space the SSD can "work with" ?

Thanks again,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
