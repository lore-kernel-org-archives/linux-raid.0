From: Bruce Dubbs <bruce.dubbs@gmail.com>
Subject: Re: ANNOUNCE: mdadm 4.0 - A tool for managing md Soft RAID under
 Linux
Date: Tue, 10 Jan 2017 11:49:04 -0600
Message-ID: <58751E90.5090306@gmail.com>
References: <1cd97490-e650-d98b-466a-095292dc5b98@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1cd97490-e650-d98b-466a-095292dc5b98@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Brown, Neil" <neilb@suse.com>
List-Id: linux-raid.ids

Jes Sorensen wrote:
> I am pleased to announce the availability of
>     mdadm version 4.0
>
> It is available at the usual places:
>     http://www.kernel.org/pub/linux/utils/raid/mdadm/
> and via git at
>     git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
>     http://git.kernel.org/cgit/utils/mdadm/
>
> The update in major version number primarily indicates this is a
> release by it's new maintainer. In addition it contains a large number
> of fixes in particular for IMSM RAID and clustered RAID support.  In
> addition this release includes support for IMSM 4k sector drives,
> failfast and better documentation for journaled RAID.

Thank you for the new release.  Unfortunately I get 9 failures running the 
test suite:

tests/00raid1...          FAILED
tests/07autoassemble...   FAILED
tests/07changelevels...   FAILED
tests/07revert-grow...    FAILED
tests/07revert-inplace... FAILED
tests/07testreshape5...   FAILED
tests/10ddf-fail-twice... FAILED
tests/20raid5journal...   FAILED
tests/10ddf-incremental-wrong-order...  FAILED

The procedure I used was

make
sudo ./test --keep-going --logdir=test-logs --save-logs

I'll also note that there is an irritating message when a test fails:
cp: cannot stat '/var/tmp/log': No such file or directory

This can be fixed easily enough with:
sed -i 's# if.* == "1"#& -a -e $targetdir/log#' test

I don't know if this mailing list is the right place to report bugs or 
not.  I do not want to spam the list with the logs but they are available at:

http://anduin.linuxfromscratch.org/~bdubbs/mdadm-logs/

   -- Bruce Dubbs
      linuxfromscratch.org
