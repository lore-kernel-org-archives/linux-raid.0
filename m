From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [md-raid6-accel PATCH 01/12] async_tx: PQXOR implementation
Date: Thu, 27 Dec 2007 18:36:08 -0800
Message-ID: <47746118.7020404@zytor.com>
References: <200712041427.00982.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200712041427.00982.yur@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yuri Tikhonov wrote:
>  This patch implements support for the asynchronous computation of RAID-6
> syndromes.
> 
>  It provides an API to compute RAID-6 syndromes asynchronously in a format
> conforming to async_tx interfaces. The async_pxor and async_pqxor_zero_sum
> functions are very similar to async_xor functions but make use of
> additional tx_set_src_mult method for setting cooefficients of the RAID-6
> Q syndrome.
> 
>  The Galois polynomial which is used in the s/w case is 0x11d (the
> corresponding coefficients are hard-coded in raid6_call.gen_syndrome).
> Because even with the h/w acceleration enabled some pqxor operations may be
> processed in CPU (e.g. in case of no DMA descriptors available) it's highly
> recommended to configure the DMA engine which your system uses to exploit
> exactly the same Galois polynomial.
> 

It should probably be noted here, too, that if you use a different basis 
polynomial for the Galois field you will end up with a different on-disk 
format.

+ * You should have received a copy of the GNU General Public License 
along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59
+ * Temple Place - Suite 330, Boston, MA  02111-1307, USA.

This address, I believe, is obsolete.

+	if (!(tx=async_pqxor(NULL, ptrs[failb],
+			&ptrs[disks - 2], bc, 0, 2, bytes,
+			ASYNC_TX_DEP_ACK | ASYNC_TX_XOR_ZERO_DST,
+			tx, NULL, NULL))) {
+		/* It's bad if we failed here; try to repeat this
+		 * using another failed disk as a spare; this wouldn't
+		 * failed since now we'll be able to compute synchronously
+		 * (there is no support for synchronous Q-only)
+		 */
+		async_pqxor(ptrs[faila], ptrs[failb],
+			&ptrs[disks - 2], bc, 0, 2, bytes,
+			ASYNC_TX_DEP_ACK | ASYNC_TX_XOR_ZERO_DST,
+			NULL, NULL, NULL);
+	}

I don't really understand this logic, or the comment that goes along 
with it.  Could you please elucidate?

	-hpa

