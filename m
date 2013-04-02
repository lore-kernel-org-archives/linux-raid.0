From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Solving the raid write performance problems
Date: Tue, 02 Apr 2013 11:10:41 -0500
Message-ID: <515B0301.7030002@hardwarefreak.com>
References: <loom.20130402T133516-865@post.gmane.org> <2420596.ZXG94NVieB@xrated>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2420596.ZXG94NVieB@xrated>
Sender: linux-raid-owner@vger.kernel.org
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Peter Landmann <sfrazt@googlemail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/2/2013 8:29 AM, Hans-Peter Jansen wrote:

> Next, check, if you can address Stan Hoeppner's remarks from that thread.
> 
> Compare test runs with variation in # of cores and numa affinity, nothing 
> else. Be careful about the SSD state regarding wear leveling. Provide 
> performance comparison charts.

NUMA affinity is only applicable for multi-socket systems, or single
socket systems using a dual die MCM CPU, such as the AMD Magny Cours and
Interlagos.  Thus any work on NUMA optimization requires such a system,
or possibly a simulator.

-- 
Stan

