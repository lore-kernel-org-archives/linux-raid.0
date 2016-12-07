From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH v2 09/12] raid5-ppl: read PPL signature from IMSM metadata
Date: Wed, 7 Dec 2016 15:38:05 +0100
Message-ID: <0e661d59-033e-6797-b5d1-d30cdb04ef11@intel.com>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
 <20161205153113.7268-10-artur.paszkiewicz@intel.com>
 <871sxk4jj0.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871sxk4jj0.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/07/2016 02:25 AM, NeilBrown wrote:
> On Tue, Dec 06 2016, Artur Paszkiewicz wrote:
> 
>> The PPL signature is used to determine if the stored PPL is valid for a
>> given array. With IMSM, the PPL signature should match the
>> orig_family_num field of the superblock. To avoid passing this value
>> from userspace, it can be read from the IMSM MPB when initializing the
>> log.
> 
> It is up to mdadm to determine if the PPL is valid.  It would only tell
> the kernel that a PPL exists if it is valid...

The kernel also has to know this value because it writes it to the PPL
header. So yet another sysfs attribute just for this value? How about
adding a directory similar to "bitmap" to hold all the PPL related
settings?

Artur
