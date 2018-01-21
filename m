From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH 0/8] Enable clustered raid testing in mdadm
Date: Sun, 21 Jan 2018 16:26:55 -0500
Message-ID: <4b61b3aa-a4e6-36b9-c013-f68455ec99fb@gmail.com>
References: <1516095909-12968-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1516095909-12968-1-git-send-email-zlliu@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/16/2018 04:45 AM, Zhilong Liu wrote:
> Hi Jes,
> 
> Since cluster-md feature has delivered and also served for SUSE distributions
> in a long time, this patch-set mainly supports to test the clustered-raid1/10,
> and provide simple example cases, the rest cases would be a new patch-set once
> the cluster-raid frame ideas got accepted.
> 
> By now, mdadm has two suites to cover testing traditional soft-raid and cluster
> raid, the new option '--testdir' would support to switch choosing which suite to
> test, leave core functions in 'test' file and move other functions to its source
> file under tests/ and clustermd_tests/ folder.

Applied!

Thanks,
Jes

