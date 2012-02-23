From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Print error message if failing to write super for 1.x
 metadata
Date: Thu, 23 Feb 2012 09:41:54 +0100
Message-ID: <4F45FBD2.80004@redhat.com>
References: <1329908516-17822-1-git-send-email-Jes.Sorensen@redhat.com> <20120223085802.57586d60@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120223085802.57586d60@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: meyering@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/22/12 22:58, NeilBrown wrote:
> On Wed, 22 Feb 2012 12:01:56 +0100 Jes.Sorensen@redhat.com wrote:
> 
>> > From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> > 
>> > In addition remove attempt to print an error message if
>> > write_init_super() fails, as this is handled in the various
>> > write_init_super() functions. This avoids a segfault on error.
>> > 
>> > Reported by Jim Meyering in
>> > https://bugzilla.redhat.com/show_bug.cgi?id=795461
>> > 
>> > Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> Applied, thanks.
> 
> Though there was already a case which printed an error which you left
> unchanged so now in some cases it would print the same message twice.
> So I removed the old printf.

Whoops, thanks for catching that.

Cheers,
Jes

