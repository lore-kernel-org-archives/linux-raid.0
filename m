From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 03/10] FIX: Add error code for raid_disks set
Date: Thu, 2 Dec 2010 10:56:32 -0800
Message-ID: <AANLkTi=mf9C9r+QM74EhMPtW35gsa2c5_QGtuxyBxn0V@mail.gmail.com>
References: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
	<20101202081904.4639.61446.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101202081904.4639.61446.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, Dec 2, 2010 at 12:19 AM, Adam Kwolek <adam.kwolek@intel.com> wrote:
> If error occurs mdadm exits with no information.
>

Unless I am missing another patch all return paths currently have an
error message?

...
        if (!ent) {
                fprintf(stderr, Name ": unable to read /proc/mdstat\n");
                return -1;
        }
...
       if (rv) {
                fprintf(stderr, Name
                        ": failed to initiate container reshape%s%s\n",
                        err ? ": " : "", err ? strerror(err) : "");
                return rv;
        }

        return changed;


...and 'changed' is never negative.

--
Dan
