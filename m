From: zhilong <zlliu@suse.com>
Subject: [PATCH] Add '--nodes' option in GROW mode
Date: Tue, 22 Mar 2016 19:44:32 +0800
Message-ID: <56F13020.8020900@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bug description:
# mdadm -Cv /dev/md0 --bitmap=clustered -l1 -n2 /dev/sdd /dev/sdb 
--nodes=6 --assume-clean
# mdadm --grow /dev/md0 --bitmap=none
# mdadm --grow /dev/md0 --bitmap=clustered
     -> cluster nodes would be changed to 4, here is my method to 
resolve it.
# mdadm --grow /dev/md0 --bitmap=clustered --nodes=6

Patch:

Cluster nodes is set 4 as default when switch bitmap from
none to clustered under GROW mode, so add '--nodes'
option in GROW mode.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
  mdadm.c | 1 +
  1 file changed, 1 insertion(+)

diff --git a/mdadm.c b/mdadm.c
index 51e16f3..b542b8c 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -592,6 +592,7 @@ int main(int argc, char *argv[])
              ident.raid_disks = s.raiddisks;
              continue;
          case O(ASSEMBLE, Nodes):
+        case O(GROW, Nodes):
          case O(CREATE, Nodes):
              c.nodes = parse_num(optarg);
              if (c.nodes <= 0) {
-- 
2.1.4

