From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID10 Performance
Date: Wed, 2 Mar 2011 14:47:41 +0000
Message-ID: <AANLkTikLqgCJW=7yjDsHxbUWV4SZg9AvCAT+TN1YZ=31@mail.gmail.com>
References: <4D6E0813.1070903@cendio.se>
	<AANLkTi=YpZYMPKVNYHTYLswOixg61Z2iJY__9sZAtC_9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=YpZYMPKVNYHTYLswOixg61Z2iJY__9sZAtC_9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Aaron Sowry <aaron@cendio.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2 March 2011 14:42, Mark Knecht <markknecht@gmail.com> wrote:
> On Wed, Mar 2, 2011 at 1:04 AM, Aaron Sowry <aaron@cendio.se> wrote:
> <SNIP>
>>
>> 2) Does md RAID1 support 'striped' reads? If not, is RAID1 read
>> performance in any way related to the number of disks in the array?
> <SNIP>
>
> RAID1 is all about redundancy/reliability and not about improving
> performance as measured by MB/S.
>
> - Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>


Sure,

But if you can get improved performance without impacting
redundancy/reliability, then why not?

Kind regards,
// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
