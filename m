From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID10 failure(s)
Date: Mon, 14 Feb 2011 18:40:53 -0600
Message-ID: <4D59CB95.1090604@hardwarefreak.com>
References: <AANLkTimqZqjJuwmC+zX3Uyx_xrWC0i07y5idrnaQXyWF@mail.gmail.com>	<AANLkTinfaYYcq1++_vx0nNMDftiv9Eqg_eDR2Q0QfoS7@mail.gmail.com>	<4D59ACAF.9020703@hardwarefreak.com> <AANLkTikyjuUo=X3m5Q6L9x3vXbgV1KC+TfOaLN2z4Keo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikyjuUo=X3m5Q6L9x3vXbgV1KC+TfOaLN2z4Keo@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Keisler <grimm26@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mark Keisler put forth on 2/14/2011 4:39 PM:
> On Mon, Feb 14, 2011 at 4:29 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>>
>> Mark Keisler put forth on 2/14/2011 2:33 PM:
>>
>>> Still wondering if there is some magic to be done to get at my data again :)
>>>>
>>>> Am I totally SOL?  Thanks for any suggestions or things to try.
>>>>
>>>> --
>>>> Mark
>>>> Tact is the ability to tell a man he has an open mind when he has a
>>>> hole in his head.
>>
>> Interesting, and ironically appropriate, sig, Mark.
>>
>> No magic is required.  Simply wipe each disk by writing all zeros with dd.  You
>> can do all 4 in parallel.  This will take a while with 1TB drives.  If there are
>> still SATA/NCQ/etc issues they should pop up while wiping the drives.  If not,
>> and all dd operations complete successfully, simply create a new RAID 10 array
>> and format it with your favorite filesystem.
>>
>> Then restore all your files from your backups.[1]
>>
>> [1] Tact is the ability to tell a man he has an open mind when he has a hole in
>> his head.
>>
>> --
>> Stan
> 
> Well, that was completely unhelpful and devoid of any information.
> Backups don't keep a RAID from failing and that's what my question was
> about.  I don't want to spend all of my time rebuilding an array and
> restoring from backup every week.

"Backups don't keep a RAID from failing" -- good sig material ;)

It seems you lack the sense of humor implied by your signature.  Given that
fact, I can understand the defensiveness.  However, note that there are some
very helpful suggestions in my reply.  IIRC, your question wasn't "how to keep a
RAID from failing" but "why did one drive in my RAID 10 fail, and then another
during rebuild".  My suggestions could help you answer the first, possibly the
second.

You still don't know if the first dropped drive is actually bad or not.  Zeroing
it with dd may very well help to inform you if there is a real problem with it.
 Checking your logs and smart data during/afterward may/should tell you.
Zeroing all of them with dd gives you a clean slate for further troubleshooting.

You don't currently have a full backup.  While the reminder of such may have
irritated you, it is nonetheless very relevant, and useful, especially for other
list OPs not donning a Jimmy hat.  RAID is not a replacement for a proper backup
procedure.  You (re)discovered that fact here, or you simply believe, foolishly,
the opposite.

My reply was full of useful information.  Apparently just not useful to someone
who wants to cut corners without having to face the potential negative consequences.

RAID won't save you from massive filesystem corruption.  A proper backup can.
And if this scenario would have turned dire (or still does) it could save you
here as well.  Again, you need a proper backup solution.

-- 
Stan

Backups don't keep a RAID from failing. --Mark Keisler
