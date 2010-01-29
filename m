From: Artur Wojcik <artur.wojcik@intel.com>
Subject: Re: [mdadm PATCH 0/2] Improvement: new logging library for
 mdadm/mdmon
Date: Fri, 29 Jan 2010 17:06:28 +0100
Message-ID: <1264781188.2788.99.camel@awojcik-linux>
References: <20100128155922.32091.12709.stgit@awojcik-linux>
	 <20100129205242.62e4049d@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100129205242.62e4049d@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Fri, 2010-01-29 at 09:52 +0000, Neil Brown wrote:
> I'd probably need a lot of convincing to add something like this to mdadm.
> 

I did not expect this patch to be accepted without convincing you or at
least without a lot of explanations :). What interest you the most?

The reason for this improvement/patch is:

1) to unify the way mdadm and mdmon log messages,
2) to have logs from mdadm and mdmon applications at the same time, 
3) to be able to capture log messages when system is booting, 
4) to simplify the source code. 

This all should improve problem diagnosis/resolution (complete log) and
reduce the complexity of source code (one function call, less parameters
in parent function) and simpler code is easier to maintain.

This is only the library, the next step would be to clean up the logs
i.e. mdmon does not log much. I started this in 2nd patch. 

BTW. I have a problem with patch 2/2 - it didn't appear on the list. I
tried sending it several times - is it too big?. However you should
receive it on your mailbox, if not please let me know. 

The second patch is only a proposal on how to incorporate the logging
library into mdmon/mdmadm.

At the moment all I can ask you is to try it first. The command line
works as before i.e. -v[v[v]] increases the level of verbosity and
'quiet' makes no output on terminal console only (mdadm still will be
logging to file and to syslog). 

The command line does not work for mdadm yet.

The logs are redirected to terminal console, syslog and log file with a
single function call.

There are new command line options, use them to on/off certain group of
logs and change verbosity level. The new commands are

--log-alert=[list of hives comma separated; all - for all hives]
--log-fatal=[same as above]
--log-error=[same as above]
--log-warn=[same as above]
--log-notice=[same as above]
--log-info=[same as above]
--log-debug=[same as above]

If no argument is given (optarg is null) then verbosity is changed for
generic hive only.

There will be command line options options added soon to redirect the
log messages.

Here's the list of hives: generic, io, super, ddf, mode, imsm, deamon,
all

generic - command line parser and config file parser

io - e.g. file acces errors, file seek errors, etc.

super - log messages related to super0 and super1.

ddf - log messages related to DDF volumes and containers only.

mode - log messages related to mode operations (Assemble, Create, Build,
etc) - the logs visualizing the stages of an algorithm.

imsm - the logs from all Intel modules.

deamon - the logs from mdmon deamon process and from monitor proces of
mdadm.

all - means 'perform an operation on all hives'

Thanks,
Artur


