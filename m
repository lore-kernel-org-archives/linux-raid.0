From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] man mdadm: Add note about auto-assembly during
 array reshape
Date: Wed, 23 Mar 2011 12:04:23 +1100
Message-ID: <20110323120423.1be12cc2@notabene.brown>
References: <20110322114634.30235.97064.stgit@gklab-128-013.igk.intel.com>
	<20110322114643.30235.53813.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110322114643.30235.53813.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Tue, 22 Mar 2011 12:46:43 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Add note to man that auto-assembly cannot be used for reshaped arrays.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  mdadm.8.in |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 96945ae..2285d4f 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -1665,6 +1665,12 @@ The reason for requiring arrays to be tagged with the homehost for
>  auto assembly is to guard against problems that can arise when moving
>  devices from one host to another.
>  ..
> +Note: Auto assembly cannot be used for assembling and activating arrays
> +under reshape.
> +.B Scan
> +doesn't allow for
> +.B backup\-file
> +passing, required by reshape restart and continuation.
>  
>  .SH BUILD MODE
>  

Applied with some revisions - thanks.

NeilBrown

commit 246cebdb7601fc41ee0cca9a5379cdd7dc072380
Author: Adam Kwolek <adam.kwolek@intel.com>
Date:   Wed Mar 23 12:02:28 2011 +1100

    man mdadm: Add note about auto-assembly during array reshape
    
    Add note to man that auto-assembly cannot be used for reshaped arrays.
    
    Revisions: NeilBrown
    
    Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/mdadm.8.in b/mdadm.8.in
index 9537304..982991d 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1665,6 +1665,13 @@ The reason for requiring arrays to be tagged with the homehost for
 auto assembly is to guard against problems that can arise when moving
 devices from one host to another.
 ..
+Note: Auto assembly cannot be used for assembling and activating some
+arrays which are undergoing reshape.  In particular as the
+.B backup\-file
+cannot be given, any reshape which requires a backup-file to continue
+cannot be started by auto assembly.  An array which is growing to more
+devices and has passed the critical section can be assembled using
+auto-assembly.
 
 .SH BUILD MODE
 
