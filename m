From: mostafa kishani <mostafa.kishani@gmail.com>
Subject: Re: Implementing Global Parity Codes
Date: Sat, 27 Jan 2018 17:59:19 +0330
Message-ID: <CACm9mdWs0d+Fo32AQ3prMuJhfsmECK2jBw-0O7D-KR=LNWtyvw@mail.gmail.com>
References: <CACm9mdUJLczo8zSB5UfU9Fd_6VK3+sGCYJYdaEaX0qW1cMLtYA@mail.gmail.com>
 <5A6C3A43.6030701@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A6C3A43.6030701@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for your response Wol
Well, maybe I failed to illustrate what I'm going to implement. I try
to better clarify using your terminology:
In the normal RAID5 and RAID6 codes we have one/two parities per
stripe. Now consider sharing a redundant sector between say, 4
stripes, and assume that the redundant sector is saved in stripe4.
Assume the redundant sector is the parity of all sectors in stripe1,
stripe2, stripe3, and stripe4. Using this redundant sector you can
tolerate one sector failure across stripe1 to stripe4. We already have
the parity sectors of RAID5 and RAID6 and this redundant sector is
added to tolerate an extra sector failure. I call this redundant
sector "Global Parity".
I try to demonstrate this as follows, assuming each RAID5 stripe has 3
data sectors and one parity sector.
stripe1: DATA1 | DATA2 | DATA3 | PARITY1
stripe2: PARITY2 | DATA4 | DATA5 | DATA6
stripe3: DATA7 | PARITY3 | DATA8 | DATA9
stripe4: DATA10 | DATA11 | PARITY4 | GLOBAL PARITY

and the Global Parity is taken across all data and parity as follows:
GLOBAL PARITY = DATA1 X DATA2 X DATA3 X DATA4 X DATA5 X DATA6 X DATA7
X DATA8 X DATA9 X DATA10 X DATA11 X PARITY1 X PARITY2 X PARITY3

Where "X" stands for XOR operation.
I hope it was clear.

Bests,
Mostafa

On Sat, Jan 27, 2018 at 12:07 PM, Wols Lists <antlists@youngman.org.uk> wrote:
> On 27/01/18 05:47, mostafa kishani wrote:
>> Dear All,
>>
>> I am going to make some modifications to RAID protocol to make it more
>> reliable for my case (for a scientific, and maybe later, industrial
>> purpose). For example, I'm going to hold a Global Parity (a parity
>> taken across the whole data stripe rather than a row)
>
> Except that what do you mean by "row"? Aren't you using it as just
> another word for "stripe"?
>
>  alongside normal
>> row-wise parities, to cope with an extra sector/page failure per
>> stripe. Do you have any suggestion how can I implement this with a
>> moderate effort (I mean what functions should be modified)? have any
>> of you had any similar effort?
>
> If I understand you correctly, that's easy. Raid-5 has one parity block
> per stripe, enabling it to recover from one lost disk. Raid-6 has two
> parity stripes, enabling it to recover from two lost disks, or one
> random corrupted block.
>
> Nobody's tried to do it, but it's a simple extension of the current
> setup ... why don't you implement what I call "raid-6+", where you can
> have as many parity disks as you like - in your case three. You'd need
> to take the current raid-6 code and extend it - ignore raid-5 because
> while the principle is the same, the detail is much simpler and cannot
> be extended.
>
>> I also appreciate if you guide me how can I enable DEBUG mode in mdadm.
>>
> Can't help there, I'm afraid.
>
> Cheers,
> Wol
>
