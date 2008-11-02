From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: mdraid10 regression in 2.6.27.4 (possibly earlier)
Date: Sun, 02 Nov 2008 12:27:59 +0100
Message-ID: <490D8EBF.8050400@rabbit.us>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010907060405040008010105"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------010907060405040008010105
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

Some weeks ago I upgraded from 2.6.23 to 2.6.27.4. After a failed hard
drive I realized that re-adding drives to a degraded raid10 no longer
works (it adds the drive as a spare and never starts a resync). Booting
back into the old .23 kernel allowed me to complete and resync the array
as usual. Attached find a test case reliably failing on vanilla 2.6.27.4
with no patches.

Thank you



--------------010907060405040008010105
Content-Type: text/plain;
 name="raid_test_2.6.27.4"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="raid_test_2.6.27.4"

IyEvYmluL2Jhc2gKCnNldCAtZQpbIC1lIC9kZXYvbG9vcDEgXSB8fCBtb2Rwcm9iZSBsb29w
Cgpmb3IgaSBpbiAxIDIgMyA0OyBkbwogICAgZGQgaWY9L2Rldi96ZXJvIG9mPWJsa2xvb3Bf
JGkgYnM9MTBNIGNvdW50PTEKICAgIGxvc2V0dXAgL2Rldi9sb29wJGkgYmxrbG9vcF8kaQpk
b25lCgptZGFkbSAtQyAvZGV2L21kNyAtbiA0IC1sIDEwIC1wIGYzIC9kZXYvbG9vcDEgL2Rl
di9sb29wMiAvZGV2L2xvb3AzIC9kZXYvbG9vcDQKCiMgd2FpdCBmb3Igc3luYwpzbGVlcCAy
CgptZGFkbSAtZiAvZGV2L21kNyAvZGV2L2xvb3AxCm1kYWRtIC1yIC9kZXYvbWQ3IC9kZXYv
bG9vcDEKCm1kYWRtIC1hIC9kZXYvbWQ3IC9kZXYvbG9vcDEKZm9yIGkgaW4gMSAyIDMgNDsg
ZG8KICAgIGNhdCAvcHJvYy9tZHN0YXQKICAgIHNsZWVwIDIKZG9uZQoKCm1kYWRtIC1TIC9k
ZXYvbWQ3CmZvciBpIGluIDEgMiAzIDQ7IGRvCiAgICBsb3NldHVwIC1kIC9kZXYvbG9vcCRp
CiAgICBybSBibGtsb29wXyRpCmRvbmUKCg==
--------------010907060405040008010105--
