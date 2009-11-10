From: "Darius S. Naqvi" <dnaqvi@datagardens.com>
Subject: Re: bitmap chunk size
Date: Tue, 10 Nov 2009 11:36:45 -0700 (MST)
Message-ID: <alpine.DEB.1.00.0911101123480.12026@darius>
References: <alpine.DEB.1.00.0911100933160.10087@darius> <4AF9AA92.7030604@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF9AA92.7030604@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 10 Nov 2009, Doug Ledford wrote:

> On 11/10/2009 11:39 AM, Darius S. Naqvi wrote:
>> Is there any possibility of having a bitmap chunk size of 512 bytes?
>> I know that mdadm rejects anything under 4k.  I fear that the
>> assumption of the 4k minimum is embedded fairly strongly in the code.
>> Can my fear be alleviated?
>>
>
> If you're putting any normal filesystem (with a block size of 4k) on
> this, then it makes absolutely no sense to have a bitmap size less than
> 4k as any given filesystem block is either dirty or clean, sub-block
> semantics make no sense in this scenario.  That said, unless you have a

Well, the mke2fs(8) man page says, "Valid block size values are 1024,
2048 and 4096 bytes per block.  If omitted, mke2fs block-size is
heuristically determined by the file system size..."

I always thought that filesystems typically used a block size of 4k,
but apparently there is no guarantee that that is the case.  Also, I'm
not sure what windows uses as a filesystem block size.  This is
important to me, because we're trying to use md raid 1's to
periodically synchronize blocks from a filesystem, and having
sub-chunk writes messes things up for us.  What we want is that a
whole chunk gets written, then we fiddle with things so that a
bitmap-driven resync copies those whole chunks.  The chunks were not
necessarily initialized before the write, so a sub-chunk write means
garbage data is copied in the remainder of the chunk.

We've seen this problem occur in practice, meaning either filesystems
are not using 4k (or multiple thereof) chunks, or for some reason,
writes are not 4k-aligned.  Does anyone with more knowledge of
filesystems know about this?  Perhaps we can force block size and
alignment of filesystems to make this work.

-- 
Darius S. Naqvi
dnaqvi@datagardens.com
http://www.datagardens.com
