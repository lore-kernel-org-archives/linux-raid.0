From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Bit-Rot
Date: Fri, 3 Mar 2017 22:25:55 +0100
Message-ID: <CAJH6TXgimQ9Ru58GCvaxqTZrYE9yDYh9osq2tEP_sLTfV0gQmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi to all
Wouldn't be possible to add a sort of bitrot detection on mdadm?
I know that MD is working on blocks and not files, but checksumming a
block should still be possible.

In example, if you read some blocks with dd, you can still hash the
content and verify that on next read/consistency check
