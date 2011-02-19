From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Possible HDD error, how do I find which HDD it is?
Date: Sat, 19 Feb 2011 15:37:58 +0000
Message-ID: <4D5FE3D6.8070006@anonymous.org.uk>
References: <AANLkTimV8-mciW_9z_=U_-uYLvKp7Rbh0V1N0mr7rh8v@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000804080606090107090105"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimV8-mciW_9z_=U_-uYLvKp7Rbh0V1N0mr7rh8v@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------000804080606090107090105
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19/02/2011 11:52, Mathias Burén wrote:
[...]
> What I wonder is, how do I know what device is ata3? I do have 4
> devices of that model (WD20EARS). I've tried searching in /sys but
> there's nothing of value there (or I've missed it). If dmesg only
> showed the S/N...
> I posted the smartctl --all output of all devices here in case someone
> has time to take a look:
> http://stuff.dyndns.org/logs/smart-sd[a,b,c,d,e,f,g].log

Try using Phil Turmel's excellent lsdrv script; I've attached the 
version I use on EL5, but I hacked it about to work on such an old 
distro so I wouldn't swear it will work on more recent distros; Phil's 
original that does work on more recent distros can be found in the list 
archives around 6 November last year in the thread "Determining which 
spindle is out of order".

Cheers,

John.


--------------000804080606090107090105
Content-Type: text/plain;
 name="lsdrv"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lsdrv"

IyEgL2Jpbi9iYXNoCiMKIyBFeGFtaW5lIHNwZWNpZmljIHN5c3RlbSBob3N0IGRldmljZXMg
dG8gaWRlbnRpZnkgdGhlIGRyaXZlcyBhdHRhY2hlZAojCgpmdW5jdGlvbiBkZXNjcmliZV9j
b250cm9sbGVyICgpIHsKCWxvY2FsIGRldmljZSBkcml2ZXIgbW9kcHJlZml4IHNlcmlhbCBz
bG90bmFtZQoJZHJpdmVyPSJgcmVhZGxpbmsgLWYgXCIkMS9kcml2ZXJcImAiCglkcml2ZXI9
ImBiYXNlbmFtZSAkZHJpdmVyYCIKCW1vZHByZWZpeD0iYGN1dCAtZDogLWYxIDxcIiQxL21v
ZGFsaWFzXCJgIgoJZWNobyAiQ29udHJvbGxlciBkZXZpY2UgQCAkezEjIy9zeXMvZGV2aWNl
cy99IFskZHJpdmVyXSIKCWlmIFtbICIkbW9kcHJlZml4IiA9PSAicGNpIiBdXSA7IHRoZW4K
CQlzbG90bmFtZT0iYGJhc2VuYW1lIFwiJDFcImAiCgkJZWNobyAiICBgbHNwY2kgLXMgJHNs
b3RuYW1lIHxjdXQgLWRcICAtZjItYCIKCQlyZXR1cm4KCWZpCglpZiBbWyAiJG1vZHByZWZp
eCIgPT0gInVzYiIgXV0gOyB0aGVuCgkJaWYgW1sgLWYgIiQxL2J1c251bSIgXV0gOyB0aGVu
CgkJCWRldmljZT0iYGNhdCBcIiQxL2J1c251bVwiYDpgY2F0IFwiJDEvZGV2bnVtXCJgIgoJ
CQlzZXJpYWw9ImBjYXQgXCIkMS9zZXJpYWxcImAiCgkJZWxzZQoJCQlkZXZpY2U9ImBjYXQg
XCIkMS8uLi9idXNudW1cImA6YGNhdCBcIiQxLy4uL2Rldm51bVwiYCIKCQkJc2VyaWFsPSJg
Y2F0IFwiJDEvLi4vc2VyaWFsXCJgIgoJCWZpCgkJZWNobyAiICBgbHN1c2IgLXMgJGRldmlj
ZWAge1NOOiAkc2VyaWFsfSIKCQlyZXR1cm4KCWZpCgllY2hvIC1lICIgIGBjYXQgXCIkMS9t
b2RhbGlhc1wiYCIKfQoKZnVuY3Rpb24gZGVzY3JpYmVfZGV2aWNlICgpIHsKCWxvY2FsIGVt
cHR5PTEKCXdoaWxlIHJlYWQgZGV2aWNlIDsgZG8KCQllbXB0eT0wCgkJaWYgW1sgIiRkZXZp
Y2UiID1+IF4oLispL2Jsb2NrWy86XSguKykkIF1dIDsgdGhlbgoJCQl0YXJnPSIke0JBU0hf
UkVNQVRDSFsxXX0iCgkJCWJkZXY9IiR7QkFTSF9SRU1BVENIWzJdfSIKCQkJdm5kPSIkKDwg
JHRhcmcvdmVuZG9yKSIKCQkJbWRsPSIkKDwgJHRhcmcvbW9kZWwpIgoJCQlzbj0iYHNnaW5m
byAtcyAvZGV2LyRiZGV2IDI+L2Rldi9udWxsIHwgXAoJCQkJc2VkIC1ybiAtZSBcIi9TZXJp
YWwgTnVtYmVyL3tzJV4uKycgKiguKykgKicuKlxcXCQlXFxcXDElO3A7cX1cImAiICY+L2Rl
di9udWxsCgkJCWlmIFtbIC1uICIkc24iIF1dIDsgdGhlbgoJCQkJZWNobyAtZSAiICAgICQx
OiBgZWNobyAvZGV2LyRiZGV2ICR2bmQgJG1kbCB7U046ICRzbn1gIgoJCQllbHNlCgkJCQll
Y2hvIC1lICIgICAgJDE6IGBlY2hvIC9kZXYvJGJkZXYgJHZuZCAkbWRsYCIKCQkJZmkKCQll
bHNlCgkJCWVjaG8gLWUgIiAgICAkMTogVW5rbm93biAkZGV2aWNlIgoJCWZpCglkb25lCglb
WyAkZW1wdHkgLWVxIDEgXV0gJiYgZWNobyAtZSAiICAgICQxOiBbRW1wdHldIgp9CgpmdW5j
dGlvbiBjaGVja19ob3N0ICgpIHsKCWxvY2FsIGZvdW5kPTAKCWxvY2FsIHBDb250cm9sbGVy
PQoJd2hpbGUgcmVhZCBzaG9zdCA7IGRvCgkJaG9zdD1gZGlybmFtZSAiJHNob3N0ImAKCQlj
b250cm9sbGVyPWBkaXJuYW1lICIkaG9zdCJgCgkJYmhvc3Q9YGJhc2VuYW1lICIkaG9zdCJg
CgkJaWYgW1sgIiRjb250cm9sbGVyIiAhPSAiJHBDb250cm9sbGVyIiBdXSA7IHRoZW4KCQkJ
cENvbnRyb2xsZXI9IiRjb250cm9sbGVyIgoJCQlkZXNjcmliZV9jb250cm9sbGVyICIkY29u
dHJvbGxlciIKCQlmaQoJCWZpbmQgJGhvc3QgLXJlZ2V4ICcuKy90YXJnZXRbMC05Ol0rL1sw
LTk6XSsvYmxvY2tbOi9dW14vXSsnIHxkZXNjcmliZV9kZXZpY2UgIiRiaG9zdCIKCWRvbmUK
fQoKZmluZCAvc3lzL2RldmljZXMvIC1uYW1lICdzY3NpX2hvc3QqJyB8Y2hlY2tfaG9zdAoK

--------------000804080606090107090105--
