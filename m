From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH v2 mdadm 1/1] Specify nodes number when updating cluster
 nodes
Date: Sun, 26 Jul 2020 21:44:01 +0800
Message-ID: <4441f34e-0b04-afcb-8bf7-45d3d605d438@redhat.com>
References: <1595503205-11129-1-git-send-email-xni@redhat.com>
 <5F1D476C.4090605@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5F1D476C.4090605@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org, jes@trained-monkey.org
Cc: ncroxon@redhat.com, heinzm@redhat.com
List-Id: linux-raid.ids



On 07/26/2020 05:05 PM, Wols Lists wrote:
> On 23/07/20 12:20, Xiao Ni wrote:
>> Now it allow updating cluster nodes without specify --nodes. It can write superblock
>> with zero nodes. It can break the current cluster. Add this check to avoid this problem.
>>
>> v2: It needs check c.update first to void NULL pointer reference
>                                         ^^^^
> Do you mean "avoid"?

Hi Wol

Yes. Thanks for pointing out the error. I'll re-send the patch

Regards
Xiao
