From: rich turner <rich@storix.com>
Subject: new superblock and raid10 support in mdadm
Date: Mon, 13 Sep 2004 08:16:30 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1095088590.3713.4.camel@rich>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

the latest source of mdadm has ANNOUNCE-1.7.0 which indicates there will
be a new superblock format. we are currently developing a process by
which we read the superblock ourselves and parse through the information
we need about the raid devices. our fear is that we develop the process
to read the superblock and then it changes, which could cause us to
completely rewrite the process.
if we develop a process based on the current superblock format, will it
still work with the new superblock format?
is there any documentation for the format of the old superblock and new
superblock?
will there be any indication within the superblock that indicates which
format the superblock is using?

ANNOUNCE-1.7.0 also indicated support for raid10. outstanding news!
while i understand this is still under development, we would like to
learn as much as we can about this support so that we can support it
when it is considered stable. any information you can provide is
helpful.

