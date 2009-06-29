From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Write intent bitmaps
Date: Mon, 29 Jun 2009 12:01:13 +0200
Message-ID: <87my7r1hqu.fsf@frosties.localdomain>
References: <20090628181428746.EXYX19511@cdptpa-omta03.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090628181428746.EXYX19511@cdptpa-omta03.mail.rr.com> (Leslie
	Rhorer's message of "Sun, 28 Jun 2009 13:14:23 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Neil Brown' <neilb@suse.de>, 'Carlos Carvalho' <carlos@fisica.ufpr.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Leslie Rhorer" <lrhorer@satx.rr.com> writes:

>> >  >5. What happens if the bitmap is lost or the external drive fills up?
>> >
>> > No idea.
>> 
>> If the bitmap is lost, it is just as though you didn't have a bitmap
>> (or as though all the bits in the bitmap were set to one).
>
> 	OK, what about the thread in this list where (as I recall) the
> fellow's bitmap was corrupted or lost and it evidently caused the entire
> array to go splat?  That's worrisome.
>
>> The drive filling up is not relevant.  When the bitmap is in a
>> separate file, the file is preallocated to be the right size.
>
> 	Let me take a little different tack.  I don't have any ext2 or ext3
> file systems on the server.  If I am going to set up an external bitmap, I
> am going to have to steal some space from one of the other file systems -
> perhaps from the swap area (5G), the boot file system (reiserfs - 109G), or
> the Windows XP filesystem (NTFS - 40G).  I need to be able to calculate how
> much space to steal to fit the bitmap, and allow for later expansion.

That is pretty flexible and the size is miniscule. For example my big
raid5 with internal bitmap has

      bitmap: 0/233 pages [0KB], 2048KB chunk

That is slightly less than 1MB. With 512MB bitmap I could do 4KB
chunks but from a few tests a larger chunk size is better for me.

MfG
        Goswin
