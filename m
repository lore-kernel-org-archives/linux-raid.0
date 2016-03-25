From: zhilong <zlliu@suse.com>
Subject: Re: [PATCH] mdadm:Add '--nodes' option in GROW mode
Date: Fri, 25 Mar 2016 10:22:03 +0800
Message-ID: <56F4A0CB.1040609@suse.com>
References: <56F13020.8020900@suse.com> <wrfjshzi9z1l.fsf@redhat.com>
 <56F28046.9010801@suse.com> <wrfj7fgr4z3g.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfj7fgr4z3g.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mdadm:add '--nodes' option in GROW mode, because
'Cluster nodes' is set 4 by default if the nodes
parameter is not specified when switch bitmap
from none to clustered.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
  mdadm.c | 1 +
  1 file changed, 1 insertion(+)

diff --git a/mdadm.c b/mdadm.c
index d2afcb2..58ac32a 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -589,6 +589,7 @@ int main(int argc, char *argv[])
  			ident.raid_disks = s.raiddisks;
  			continue;
  		case O(ASSEMBLE, Nodes):
+		case O(GROW, Nodes):
  		case O(CREATE, Nodes):
  			c.nodes = parse_num(optarg);
  			if (c.nodes <= 0) {
-- 
2.1.4

On 03/25/2016 12:31 AM, Jes Sorensen wrote:
> Guoqing Jiang <gqjiang@suse.com> writes:
>> On 03/23/2016 01:56 AM, Jes Sorensen wrote:
>>> zhilong <zlliu@suse.com> writes:
>>>> Bug description:
>>>> # mdadm -Cv /dev/md0 --bitmap=clustered -l1 -n2 /dev/sdd /dev/sdb
>>>> --nodes=6 --assume-clean
>>>> # mdadm --grow /dev/md0 --bitmap=none
>>>> # mdadm --grow /dev/md0 --bitmap=clustered
>>>>       -> cluster nodes would be changed to 4, here is my method to
>>>> resolve it.
>>>> # mdadm --grow /dev/md0 --bitmap=clustered --nodes=6
>>>>
>>>> Patch:
>>>>
>>>> Cluster nodes is set 4 as default when switch bitmap from
>>>> none to clustered under GROW mode, so add '--nodes'
>>>> option in GROW mode.
>>>>
>>>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>>>> ---
>>>>    mdadm.c | 1 +
>>>>    1 file changed, 1 insertion(+)
>>> Hi,
>>>
>>> I have a question about this, since I simply do not have the knowledge
>>> about clustering to judge this approach.
>>>
>>> If you remove the bitmap, does that 'uncluster' the array? If not,
>> Yes, remove the bitmap would 'uncluster' the array since leave()
>> will be called in kernel if switch the bitmap from 'clustered' to
>> 'none'.
>>
>>> shouldn't mdadm be fixed to not set #nodes to 4 when adding a clustered
>>> bitmap, if a number of cluster nodes is already present?
>> The nodes is set 4 by default if the 'nodes' parameter is not specified,
>> And it could be overwrite if re-create the clustered bitmap.
> Thanks for the explanation, in that case I am fine with this. It does
> raise the issue whether specifying nodes shouldn't be a required
> argument rather than defaulting to a default of 4?
>
> Second, your patch was broken due to bad whitespace formatting, could
> you please send me a fresh one.
>
> Thanks,
> Jes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

