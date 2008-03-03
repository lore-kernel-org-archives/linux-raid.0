From: "Nicolas Mella" <nmella@kepler.cl>
Subject: Re: Corrupted RAID 50 (aparently?) array. Help needed.
Date: Sun, 2 Mar 2008 21:28:00 -0300
Message-ID: <f4d3d9a30803021628yd98a89fgcd116091031d4476@mail.gmail.com>
References: <20080228102209.2hgng57tyck44k8o@www.kepler.cl>
	 <47C9BD0F.7020808@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47C9BD0F.7020808@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 1, 2008 at 5:31 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> nmella@kepler.cl wrote:
>  > Hi list,
>  >
>  > Hope someone can give me the right direction on how to resolve this.
>
>  Were you under the impression that this list is a professional service
>  where people are paid to give you good response? You sent the first copy
>  of your question at 10:42, got impatient and resent at 11:04, then 11:15
>  and 11:22. Sorry we don't respond fast enough for you, perhaps you
>  should take your business elsewhere.
>
>  --
>  Bill Davidsen <davidsen@tmr.com>
>   "Woe unto the statesman who makes war without a reason that will still
>   be valid when the war is over..." Otto von Bismark


Sorry list. I know my mistake  and I am totally embarrassed.....

I just read everywhere that majordomo filter almost everything....so I
thought my emails where been filtered.... (list emails are dispatch
with a very long delay).

Sorry.

For sure I don't think this is a professional service. I just wanted
help on my problem which this list seem to be the right solution.

Well, anyway I could re-assemble the RAID myself.

If is it useful for someone here goes the solution:

Using Winhex software, I assemble  both RAID5 groups considering the
sequence that was detail by the "mdadm --examine option". (RAID5 type
AMI backward dynamic)

Having both 1,0 TB disks the Testdisk program said they had LVM partion.

So I activated them using "vgscan" and "vgchange -a y" and then I just
mount the partion. ufffff

Sorry for all the trouble.

Have a nice day.

Nicolas
