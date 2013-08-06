From: Martin Wilck <mwilck@arcor.de>
Subject: DDF: regression caused by 273989b9 / ce45c819
Date: Tue, 06 Aug 2013 20:14:35 +0200
Message-ID: <52013D0B.8060404@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

these patches break the unit test 10ddf-geometry. I saw the regression
with both patches applied. The problem occurs when subarrays are
deleted. With these patches in place, sync_metadata() will not overwrite
deleted conf records on disk, but lseek() over them instead. When the
meta data is read back, this will cause errors.

I would like to ask you to play safe here and revert these patches. It
might be possible to fix the --kill-subarray problem, but there are
other possible scenarios where the number of valid conf records on a
disk decreases - I don't think we have a reliable way to check whether
it is safe to skip over empty entries. We must also be prepared for
other DDF implementations to read our meta data, so we must refrain from
putting any writing anything that might be confusing.

Regards
Martin
