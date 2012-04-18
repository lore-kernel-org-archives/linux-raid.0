From: Tom Rini <tom.rini@gmail.com>
Subject: Any 3.4-rc3 known issues?
Date: Wed, 18 Apr 2012 12:10:12 -0700
Message-ID: <CA+M6bXmYkMYVb8UtSfJNU4tgSZhbccw2MfZqFiKpfLnLc8hknQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey all,

Related to my last post, is there a list of 3.4-rc3 known issues?
I've got a small setup that works fine on 3.3.0 and 3.4-rc3 seems to
be destroying part of the metadata (but nothing else, recreate and
fsck is fine) on.  I'm doing a bisect now under the assumption it's
not...  Thanks!

-- 
Tom
