From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH v2 00/12] Partial Parity Log for MD RAID 5
Date: Wed, 4 Jan 2017 09:01:05 +0100
Message-ID: <84d3a102-faef-13ae-44e2-2f9a4d561c37@intel.com>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
 <87fum04m0m.fsf@notabene.neil.brown.name>
 <84c59771-48b7-da47-3497-c82c6c6939c9@intel.com>
 <20161207170906.sthdxswufwk5fqhn@kernel.org> <wrfjy3zjq2b3.fsf@redhat.com>
 <20161214194726.4to3rnqyrqlqlx7t@kernel.org>
 <c97a46de-f88a-f8f2-4520-e3c8a57d1b3b@intel.com>
 <20161216232421.x6sb4goclzyasu6k@kernel.org> <wrfjzij8ywtu.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjzij8ywtu.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/03/2017 04:42 PM, Jes Sorensen wrote:
> Artur,
> 
> Did you make any progress getting the alignment issue resolved?
> 
> I'd really like to get an mdadm release out the door this week, so
> getting this resolved would be awesome. Hint hint ;)

Jes,

The alignment issue is fixed but I'm currently making changes in the
kernel part after comments from Neil. This also requires modifications
in mdadm, maybe even more than in the kernel. I need a few more days to
finish this, I'll be sending the next version of the patches probably
next week. So don't let me keep you if you want to make a release this
week.

Thanks,
Artur
