From: Franck Routier <franck.routier@axege.com>
Subject: 2x6 or 3x4 raid10 arrays ?
Date: Thu, 28 Feb 2008 11:45:54 +0100
Message-ID: <1204195554.16924.16.camel@franck-gusty>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am installing a database (postgresql) server.
I am considering two options:
- either setup two 6 disks raid10 arrays
- or setup three 4 disks raid10 arrays

You guessed I have 12 disks :)

Raw performance is better on 6 disks arrays, but having 3 arrays allows
me to setup 3 tablespaces and maybe to achieve better parallelism.

I am under the impression that I will get better results with requests
spread over 3 less effective arrays rather than two slightly more effive
one.

Does it make any sense, or am I totally missing the point ?

Thanks,
Franck


