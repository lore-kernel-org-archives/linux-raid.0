From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: One raid array does not show up with mdadm --examine --scan
Date: Mon, 15 Mar 2010 14:41:46 -0700
Message-ID: <40b437201003151441t1f2b78cfg901ccae97c893456@mail.gmail.com>
References: <40b437201003151113i15ad2a57y3b4f3ac4e18a8ad6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40b437201003151113i15ad2a57y3b4f3ac4e18a8ad6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 15, 2010 at 11:13 AM, Simon Matthews
<simon.d.matthews@gmail.com> wrote:
> On my newly built machine, in which all filesystems are on RAID array,
> one of the arrays does not show up with the command:
> mdadm --examine --scan
>
> Why is this? And is there anything I can do to fix it?


I suspect that I may have found an answer to this question -- the
array that does not show up is formed from partitions that are logical
partitions instead of primary partitions. I'll try deleting the
partitions and re-creating as primary.

Simon
