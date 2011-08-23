From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: [PATCH] md.4: two typos fixed
Date: Tue, 23 Aug 2011 01:06:53 +0100
Message-ID: <4E52EF1D.1090707@anonymous.org.uk>
References: <4E5290C1.5050400@bogoflop.com> <20110823091524.7b5d1014@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110823091524.7b5d1014@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Bill Allaire <vger@bogoflop.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 23/08/2011 00:15, NeilBrown wrote:
> On Mon, 22 Aug 2011 13:24:17 -0400 Bill Allaire<vger@bogoflop.com>  wrote:
>
>> Signed-off-by: Bill Allaire<vger@bogoflop.com>
>> ---
>>    md.4 |    4 ++--
>>    1 files changed, 2 insertions(+), 2 deletions(-)
[...]
> However the patch was corrupted a bit - most of the lines had 2 leading
> spaces where they should have had one.  It was easy enough to fix it but for
> a larger patch it would be a problem.
>
> There is presumably some way to tell Thunderbird to send the text verbatim
> and not reformat it, but I have no idea what that way would be...

That'll be format=flowed and its space-stuffing to protect some lines. 
I'm not clear why lines which begin with one space need an extra one 
added. Anyway.

Yes, Thunderbird can have format=flowed disabled by setting 
mailnews.send_plaintext_flowed to false in the config editor, or you can 
send really plain text line a patch by attaching it.

Cheers,

John.

