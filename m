From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH] kill-subarray: fix, cannot kill-subarray with unsupported metadata
Date: Tue, 6 Sep 2011 12:16:43 -0700
Message-ID: <CABE8wwsfrdgZcHzOdTpA-EM1R8fknw7hCT1+VHGus5h-Pa-3pA@mail.gmail.com>
References: <F9123E44003394499FDD2B17C60621D401BE07@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F9123E44003394499FDD2B17C60621D401BE07@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Mon, Sep 5, 2011 at 7:23 AM, Labun, Marcin <Marcin.Labun@intel.com> wrote:
> Subject: [PATCH] kill-subarray: fix, cannot kill-subarray with unsupported metadata
>
> container_content retrieves volume information from disks in the container.
> For unsupported volumes the function was not returning mdinfo. When all volumes
> were unsupported the function was returning NULL pointer to block actions on the volumes.

Isn't this the purpose of ->ignore_hw_compat?

So we could do something simpler like the following instead?

diff --git a/Kill.c b/Kill.c
index b841a5b..11b27a6 100644
--- a/Kill.c
+++ b/Kill.c
@@ -97,7 +97,9 @@ int Kill_subarray(char *dev, char *subarray, int quiet)

        memset(st, 0, sizeof(*st));

+       st->ignore_hw_compat = 1;
        fd = open_subarray(dev, subarray, st, quiet);
+       st->ignore_hw_compat = 0;
        if (fd < 0)
                return 2;
