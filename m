From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch 1/2]raid5: set bio bi_vcnt 0 for discard request
Date: Wed, 23 Oct 2013 04:07:19 -0400
Message-ID: <yq14n88h0lk.fsf@sermon.lab.mkp.net>
References: <20131019065028.GA10670@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131019065028.GA10670@kernel.org> (Shaohua Li's message of
	"Sat, 19 Oct 2013 14:50:28 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

>>>>> "Shaohua" == Shaohua Li <shli@kernel.org> writes:

Shaohua> SCSI layer will add new payload for discard request. If two
Shaohua> bios are merged to one, the second bio has bi_vcnt 1 which is
Shaohua> set in raid5. This will confuse SCSI and cause oops.

A discard bio does not have a payload prior to the SCSI command being
prepared so vcnt should indeed be 0.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
