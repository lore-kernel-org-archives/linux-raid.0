From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH v2] mdadm: set journal_clean after scanning all disks
Date: Fri, 1 Sep 2017 11:12:55 -0400
Message-ID: <48c74e1d-4cfc-5624-1065-36d2f44f0dac@gmail.com>
References: <20170829165302.3526230-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170829165302.3526230-1-songliubraving@fb.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org
List-Id: linux-raid.ids

On 08/29/2017 12:53 PM, Song Liu wrote:
> Summary:
> In Incremental.c:count_active(), max_events is tracked to show to
> which devices are up to date. If a device has events==max_events+1,
> getinfo_super() is called to reload the superblock from this
> device. getinfo_super1() blindly set journal_clean to 0, which is
> wrong.
> 
> This patch fixes this by tracking max_journal_events for all the
> disks. After scanning all disks, journal_clean is set if
> max_journal_events >= max_events-1.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>

Applied!

Thanks,
Jes

