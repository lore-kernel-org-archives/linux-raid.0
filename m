From: Lukas Kubin <kubin@opf.slu.cz>
Subject: Array of disks attached to multiple controllers
Date: Tue, 14 Sep 2004 15:21:32 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4146F05C.9090206@opf.slu.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms080907000806060001040709"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms080907000806060001040709
Content-Type: multipart/mixed;
 boundary="------------030403080500050301030603"

This is a multi-part message in MIME format.
--------------030403080500050301030603
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I'm having troubles creating Raid-5 array consisted of 16 (+1 spare) 
disks attached to two 3ware (not same version) SATA controllers.

Mkraid creates the array without problems, however the array's total 
size only equals the sum of space on drives attached to the first of 2 
controllers. Ie, sd{b..f} are on scsi0 and sd{g..r} on scsi1. The space 
of created array is close to the sum of drives attechted to scsi0 only.

Is it possible to combine drives on 2 controllers into one array? If 
not, what solution should I use to have one filesystem containing whole 
the drivespace on Raid-5?

Thank you.

lukas

-- 
Lukas Kubin

phone: +420596398275
email: kubin@opf.slu.cz

Information centre
The School of Business Administration in Karvina
Silesian University in Opava
Czech Republic
http://www.opf.slu.cz

--------------030403080500050301030603
Content-Type: text/x-vcard; charset=utf-8;
 name="kubin.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kubin.vcf"

begin:vcard
fn:Lukas Kubin
n:Kubin;Lukas
org:The School of Business Administration in Karvina;Information centre
adr:;;Univerzitni namesti 1934/3;Karvina;;73340;Czech Republic
email;internet:kubin@opf.slu.cz
title:Network administrator
tel;work:+420596398275
x-mozilla-html:FALSE
url:http://www.opf.slu.cz
version:2.1
end:vcard


--------------030403080500050301030603--

--------------ms080907000806060001040709
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
--------------ms080907000806060001040709--
