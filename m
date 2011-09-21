From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH] imsm: FIX: Spare disk has wrong serial after takeover
Date: Tue, 20 Sep 2011 23:05:33 -0700
Message-ID: <CABE8wwt9zWzpwkCeOddY7Xa4+q7XnVyOKib6Mm1d5+68iCPoMg@mail.gmail.com>
References: <20110915163839.5674.99218.stgit@gklab-128-013.igk.intel.com>
	<20110919132232.5b4de2a8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110919132232.5b4de2a8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Adam Kwolek <adam.kwolek@intel.com>, linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

On Sun, Sep 18, 2011 at 8:22 PM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 15 Sep 2011 18:38:39 +0200 Adam Kwolek <adam.kwolek@intel.com> wrote:
>
>> Takeover marks disk as failed and adds to serial ':0' string and then
>> turns it in to spare. This causes that when new spare is about to be used,
>> it cannot be found due to different disk serial number.
>>
>> Restore disk serial number to avoid this problem.
>>
>> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
>
> This looks believeable, and I really like the fact that you have factored out
> 'mark_spare' as a separate function rather having something open-coded at
> various points.
>
> I can't really say if it is 'right' as I don't understand all the details of
> exactly how serial numbers are supposed to work.
> So I'll apply it and hope than Dan will speak up if he sees any problems.
>

The assembly process checks "in the 'best' super can I look my self up
by serial number".  So if the best super does not have a record of
your serial number then you are an "offline array member".  However I
don't understand the failed-to-spare transition and why the takeover
process can't hide the intermediate failed state from being written to
the metadata.  Maybe that's hard to avoid, but temporarily recording a
fib to the metadata seems to leave a window for confusion.

--
Dan
