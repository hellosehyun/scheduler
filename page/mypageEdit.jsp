<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="../style/init.css">
    <link rel="stylesheet" href="../style/mypageEdit.css">
</head>

<body class="mypageEdit-body">
    <div class="mypageEdit-box">
        <h1 class="mypageEdit-box-title">
            <span>스케</span><span class="mypageEdit-box-title-lightBlue">줄러</span>
        </h1>
        <a class="mypageEdit-box-back">스케줄러 페이지로 돌아가기</a>
        <div class="mypageEdit-box-subtitle">내 정보</div>
        <div class="mypageEdit-box-info">
            <div class="mypageEdit-box-info-item">
                <div class="mypageEdit-box-info-item-left">
                    이름
                </div>
                <input placeholder="이름을 입력해주세요" class="mypageEdit-box-info-item-right" type="text">
            </div>
            <div class="mypageEdit-box-info-item">
                <div class="mypageEdit-box-info-item-left">
                    이메일
                </div>
                <input placeholder="이메일을 입력해주세요" type="email" class="mypageEdit-box-info-item-right">
            </div>
            <div class="mypageEdit-box-info-item">
                <div class="mypageEdit-box-info-item-left">
                    비밀번호
                </div>
                <input placeholder="비밀번호를 입력해주세요" class="mypageEdit-box-info-item-right" type="password">
            </div>
            <div class="mypageEdit-box-info-item">
                <div class="mypageEdit-box-info-item-left">
                    비밀번호 확인
                </div>
                <input placeholder="비밀번호를 다시 입력해주세요" class="mypageEdit-box-info-item-right" type="password">
            </div>
            <div class="mypageEdit-box-info-item">
                <div class="mypageEdit-box-info-item-left">
                    부서
                </div>
                <select class="mypageEdit-box-info-item-right" name="" id="">
                    <option class="mypageEdit-box-info-item-right-default" disabled selected>
                        직급을 선택해주세요
                    </option>
                    <option>
                        팀원
                    </option>
                    <option>
                        팀장
                    </option>
                </select>
            </div>
            <div class="mypageEdit-box-info-item">
                <div class="mypageEdit-box-info-item-left">
                    직급
                </div>
                <select class="mypageEdit-box-info-item-right" name="" id="">
                    <option class="mypageEdit-box-info-item-right-default" disabled selected>
                        직급을 선택해주세요
                    </option>
                    <option>
                        팀원
                    </option>
                    <option>
                        팀장
                    </option>
                </select>
            </div>
        </div>
        <div class="mypageEdit-box-manage">
            <button class="mypageEdit-box-manage-cancel">취소</button>
            <button class="mypageEdit-box-manage-save">저장</button>
        </div>
    </div>
</body>

</html>