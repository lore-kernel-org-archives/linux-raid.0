From: "Mike Snitzer" <snitzer@gmail.com>
Subject: issue with mdadm ver1 sb and bitmap on x86_64
Date: Sat, 5 Aug 2006 19:46:45 -0400
Message-ID: <170fa0d20608051646w65f2d541hd88003a2e1d13bdb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

FYI, with both mdadm ver 2.4.1 and 2.5.2 I can't mdadm --create with a
ver1 superblock and a write intent bitmap on x86_64.

running: mdadm --create /dev/md2 -e 1.0 -l 1 --bitmap=internal -n 2
/dev/sdd --write-mostly /dev/nbd2
I get: mdadm: RUN_ARRAY failed: Invalid argument

Mike
